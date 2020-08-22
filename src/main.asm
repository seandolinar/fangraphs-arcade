.include "./res.asm"
.include "./header.asm"
.include "./reset.asm"
.include "./controller/controller.asm"
.include "./controller/readKonamiCode.asm"
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
    ; JSR readController

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

