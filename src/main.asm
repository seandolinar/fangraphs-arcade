.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
.include "./player/playerAnimation.asm"
.include "./player/playerReset.asm"
.include "./enemy/enemy.asm"
.include "./enemy/enemyAI.asm"
.include "./enemy/enemyCollision.asm"
.include "./enemy/enemyPowerUp.asm"
.include "./enemy/enemyReset.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"
.include "./ppuUpdates.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"
.include "./tiles.asm";

.segment "TILES"
.incbin "../chr/char02.chr"

.segment "MUSIC"
.incbin "../nsf/export1.nsf", $80 ; offset of $80 so I don't have to trim this 


.segment "CODE"
NMI:

    ; Preserves the registers during the course of the interrupt
    PHA
    TXA
    PHA
    TYA
    PHA

    LDA gameOuts
    CMP #$03
    BEQ @endGame



; vBlankWait:	
@vBlankLoop:
	lda $2002   
    bpl @vBlankLoop

    JSR changeBackground
    JSR spriteTransfer

    LDA gamePlayerReset ; $01 means we are in the middle of a reset
    BNE @resetNMI

    LDX masterTimer
    DEX
    STX masterTimer
    BNE @dumpNMI
    LDA #$08            ; makes sure we don't loop backwards
    STA masterTimer
   
@dumpNMI:
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

@resetNMI:
    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    AND controllerBits
    AND #CONTROL_P1_A  ; zeros out non-start bits
    BEQ @dumpReset
    LDA #$00
    STA gamePlayerReset

    @dumpReset:
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

@endGame:
    ; kills the game at three outs
    ; JSR endGame
    JSR changeBackground
    JSR writeGameOver
    RTI

IRQ:
    RTI

; we are updating the position in MAIN
; but checking the position in NMI
Main:
    ; have to write this branch
    ; LDA gameOuts
    ; CMP #$03
    ; BEQ resetHard

    LDA gamePlayerReset
    BNE Main

    

    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev
    AND controllerBits
    AND #CONTROL_P1_START
    BEQ @continue
    
    @pauseLoop:
    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    AND controllerBits
    AND #CONTROL_P1_START  ; zeros out non-start bits
    BEQ @pauseLoop

    @continue:
    LDY controlTimer
    CPY #$00
    BNE @exit
    JSR readController

    JSR updateDirection
    LDY #$30

    @exit:
    DEY
    STY controlTimer  

    LDX masterTimer
    CPX #$01
    BEQ @runMovement
    JMP Main                ; loops because of end

    @runMovement:
    LDX #$08                ; need to reset this
    STX masterTimer
    JSR nmiMovement
    JMP Main

resetHard:
    ; right idea, but I need to more gracefully restart
    ; maybe go back to the title screen?
    ; maybe break up the reset stuff up so i can resue it
    JMP RESET

nmiMovement:
    JSR incTimerPowerUp

    JSR dumpUpdatePosition      ; runs the player updates ;change this to update direction
    ; this should handle when to move the sprites
    JSR checkCollisionSprites ; this isn't working

    JSR setAnimationPlayerMain
    JSR setAnimationPlayerDirection
    JSR checkCollisionSprites ; this isn't working
    JSR checkCollisionPowerUp
    JSR nextEnemyMovement   ; move this to main?
    JSR checkCollisionSprites ; this isn't working

    INC enemyMode

    JSR checkWin          ; maybe this sits well here?

@dump:
    RTS




; move this
writeGameOver:
    ; abstract this
    ; do we need to find the last item in the buffer?
    ; or track that in another byte of RAM?
    LDA #<vram_buffer
    STA nametable_buffer_lo
    LDA #>vram_buffer
    STA nametable_buffer_hi

    ; writes game over with letters
    ; i need the array of tiles
    ; i need the starting address (but that's low and high bytes)
    LDY #$01
    LDX #$00

    @loop:
    LDA #$20
    STA (nametable_buffer_lo), Y

    INY

    ; might have to do math here
    CLC
    TXA
    ADC #$EC
    STA (nametable_buffer_lo), Y

    INY

    LDA textGameOver, X
    STA (nametable_buffer_lo), Y

    INX
    INY

    CPX #$09
    BNE @loop

    @dump:
    RTS