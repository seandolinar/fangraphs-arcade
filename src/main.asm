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

    ; this interrupts the main loop
   ; CHECK PAUSE
    ; Pause:
    ; LDA controllerBits
    ; AND #CONTROL_P1_START
    ; BNE @vBlankLoop
    
    ; RTI
    ; LDA gamePaused
    ; CMP #$01
    ; BNE @vBlankLoop

    ; RTI

  


; vBlankWait:	
@vBlankLoop:
	lda $2002   
    bpl @vBlankLoop

    JSR changeBackground
    JSR spriteTransfer
    ; JSR readController

    ; plays music, but this crashes horribly
    ; LDA #$00
    ; LDX #$00
    ; JSR $8060


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
    ; LDA $2001
    ; EOR #%0001000
    ; STA $2001

    ; LDA $2000
    ; EOR #%1000000
    ; STA $2000

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

IRQ:
    RTI

; we are updating the position in MAIN
; but checking the position in NMI
Main:
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

