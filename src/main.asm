.include "./res.asm"
.include "./header.asm"
.include "./reset.asm"
.include "./controller.asm"
.include "./player/playerCollision.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
.include "./player/playerAnimation.asm"
.include "./player/playerReset.asm"
.include "./enemy/enemy.asm"
.include "./enemy/enemyAI.asm"
.include "./enemy/enemyAIMath.asm"
.include "./enemy/enemyBattedBall.asm"
.include "./enemy/enemyCollision.asm"
.include "./enemy/enemyPowerUp.asm"
.include "./enemy/enemyReset.asm"
.include "./enemy/enemyEntranceDoor.asm"
.include "./scoreboard/updateScore.asm"
.include "./scoreboard/updateInning.asm"
.include "./checkCollision/checkCollisonPowerUp.asm"
.include "./checkCollision/checkCollisonSprites.asm"
.include "./ppu/ppuUpdates.asm"
.include "./ppu/vram.asm"
.include "./ppu/FillBackground.asm"
.include "./ppu/clearOutSprites.asm"
.include "./load/loadSplashScreen.asm"
.include "./load/loadGameOver.asm"
.include "./load/loadWinScreen.asm"
.include "./load/loadFullScreen.asm"
.include "./load/loadGameBoard.asm"


; sound files
.include "../lib/famitone2.s"
.include "./sound/music.s"
.include "./sound/sfx.s"
.include "./sound/sound.asm"

; graphics
.include "./graphics/pallete.asm"
.include "./graphics/tiles.asm";

.segment "TILES"
.incbin "../chr/nes-fg.chr"

.segment "CODE"
.include "./nmi.asm"

IRQ:
    RTI


resetHard:
    ; right idea, but I need to more gracefully restart
    ; maybe go back to the title screen?
    ; maybe break up the reset stuff up so i can resue it
    LDA #$00  ; disable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPU_CTRL_REG1
    STA PPU_CTRL_REG2

    JMP loadGameOver

; we are updating the position in MAIN
; but checking the position in NMI
Main:
    ; have to write this branch
    LDA gameOuts
    CMP #$03
    BEQ resetHard

    ; WIN

    LDA gamePlayerReset
    BNE Main

    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev
    AND controllerBits
    AND #CONTROL_P1_START
    BEQ @continue
    
    LDA #$00
    STA gamePaused
    
    @pauseLoop:

    LDA gamePaused
    CMP #$00
    BNE @continuePauseLoop

    @musicPauseLoop:
   
    LDA #$04
	JSR FamiToneMusicPlay

    INC gamePaused

    @continuePauseLoop:
    LDA gamePaused
    ORA #$01
    STA gamePaused

    JSR readKonamiCode

    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    AND controllerBits
    AND #CONTROL_P1_START  ; zeros out non-start bits
    BEQ @pauseLoop

    LDX #$00 ; i'm not blowing away anything? TODO
    STX gamePaused
    JSR FamiToneMusicStop

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

    JSR battedBallFlashing

    LDX masterTimer
    CPX #$01
    BEQ @runMovement
    JMP Main                ; loops because of end

    @runMovement:
    LDX #$08                ; need to reset this
    STX masterTimer
    
    JSR clearVRAMBuffer
    JSR gameMovement
    JSR writeOutScoreVram
    JMP Main

gameMovement:
    JSR UpdatePositionPlayer    ; runs the player updates ;change this to update direction
    JSR setAnimationPlayerDirection

    JSR checkCollisionSprites   ; this should handle when to move the sprites ; I don't think I need this here

    ; skips over this section if we are resetting because of an out
    LDA gamePlayerReset
    BNE @dump

    JSR checkCollisionPowerUp

    JSR nextEnemyMovement   ; move this to main?
    JSR checkCollisionSprites
    JSR checkDoor
    JSR incTimerPowerUp

    INC enemyMode

    JSR checkWin          ; maybe this sits well here?

@dump:
    RTS




readKonamiCode:
    ; TODO
    ; refactor into loop
   

    ; LDA buttonDebounce
    ; CMP frameTimer
    ; BEQ @readButton
    ; JMP @exit

    ; @readButton:

    LDA konamiCode
    CMP #$00
    BEQ @buttonUp
    CMP #$01
    BEQ @buttonNone
    CMP #$02
    BEQ @buttonUp
    CMP #$03
    BEQ @buttonNone
    CMP #$04
    BEQ @buttonDown
    CMP #$05
    BEQ @buttonNone
    CMP #$06
    BEQ @buttonDown
    CMP #$07
    BEQ @buttonNone
    CMP #$08
    BEQ @buttonLeft
    CMP #$09
    BEQ @buttonNone
    CMP #$0a
    BEQ @buttonRight
    CMP #$0b
    BEQ @buttonNone
    CMP #$0c
    BEQ @buttonLeft
    CMP #$0d
    BEQ @buttonNone
    CMP #$0e
    BEQ @buttonRight
    CMP #$0f
    BEQ @buttonNone
    CMP #$10
    BEQ @buttonB
    CMP #$11
    BEQ @buttonNone
    CMP #$12
    BEQ @buttonA
    JMP @skipButton

    @buttonNone:
    JSR readController ; not sure if I need this
    LDA controllerBits
    BNE @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonUp:
    LDA controllerBits
    AND #CONTROL_P1_UP
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonDown:
    LDA controllerBits
    AND #CONTROL_P1_DOWN
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonLeft:
    LDA controllerBits
    AND #CONTROL_P1_LEFT
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonRight:
    LDA controllerBits
    AND #CONTROL_P1_RIGHT
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonA:
    LDA controllerBits
    AND #CONTROL_P1_A
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonB:
    LDA controllerBits
    AND #CONTROL_P1_B
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode
   
    @continueCode:
    CLC
    LDA frameTimer
    ADC #$30
    STA buttonDelay

    ; LDA #$05
    ; STA buttonDebounce

    ; CLC
    ; LDA frameTimer
    ; ADC #$05
    ; STA buttonDebounce
    ; JMP @exit

    LDA konamiCode
    CMP #$13
    BEQ @continueLoop

    JMP @skip
    
    @continueLoop:
    JSR FamiToneMusicStop
    JSR soundPowerUp
    JSR enablePowerUp
    LDA #$01
    STA hasCheated
    JMP @exit


    @skipButton:
    LDA buttonDebounce
    CMP frameTimer
    BNE @exit
    LDA controllerBits
    CMP #$00
    BNE @resetKonamiCode

    JMP @exit

    @resetKonamiCode:
    LDA #$00
    STA konamiCode

    JMP @exit

    @skip:
    LDA frameTimer
    ADC #$10
    STA buttonDebounce
    
    @exit:
    RTS