.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./player/playerCollision.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
.include "./player/playerAnimation.asm"
.include "./player/playerReset.asm"
.include "./enemy/enemy.asm"
.include "./enemy/enemyAI.asm"
.include "./enemy/enemyCollision.asm"
.include "./enemy/enemyPowerUp.asm"
.include "./enemy/enemyReset.asm"
.include "./score/updateScore.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"
.include "./ppuUpdates.asm"
.include "./load/loadSplashScreen.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./load/loadGameBoard.asm"
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
    JSR clearVRAMBuffer

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
    LDA gameOuts
    CMP #$03
    BEQ resetHard

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
    LDA #$00  ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000
    STA $2001

    JMP InitialLoad

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




