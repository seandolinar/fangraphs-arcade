.include "./res.asm"
.include "./header.asm"
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
.include "./enemy/enemyEntranceDoor.asm"
.include "./score/updateScore.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"
.include "./ppu/ppuUpdates.asm"
.include "./ppu/vram.asm"
.include "./load/loadSplashScreen.asm"
.include "./load/loadGameOver.asm"
.include "../lib/famitone2.s"
.include "./sound/music.s"
.include "./sound/SFX_New.s"


.include "./reset.asm"
.include "./pallete.asm"
.include "./load/loadGameBoard.asm"
.include "./tiles.asm";

.segment "TILES"
.incbin "../chr/nes-fg.chr"

.segment "MUSIC" ; TODO eliminate


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
	LDA $2002   
    BPL @vBlankLoop

    LDA #$00
	STA PPU_CTRL_REG1               ; disable NMI
	STA PPU_CTRL_REG2               ; disable rendering

    INC frameTimer

    JSR changeBackground
    JSR spriteTransfer


    ; STARTS VIDEO DISPLAY
    LDA PPUState            ; using state from the code
    STA PPU_CTRL_REG1

    LDA #%00011110          ; enable sprites, enable background, no clipping on left side
    STA PPU_CTRL_REG2

    ; resets scroll
    ; not sure why I have to do this, but it works!!
    LDA #$00
    STA PPU_SCROLL_REG 
    STA PPU_SCROLL_REG

    LDA gamePlayerReset ; $01 means we are in the middle of a reset
    BNE @resetNMI

    LDX masterTimer
    DEX
    STX masterTimer
    BNE @dumpNMI
    LDA #$08            ; makes sure we don't loop backwards
    STA masterTimer

@dumpNMI:

    JSR FamiToneUpdate		;update sound

    JSR clearVRAMBuffer

    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

@resetNMI:

    jsr FamiToneUpdate		;update sound

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

    ; LDX #$02
    ; STX gamePaused

    INC gamePaused

    @continuePauseLoop:
    LDA gamePaused
    ORA #$01
    STA gamePaused

    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    AND controllerBits
    AND #CONTROL_P1_START  ; zeros out non-start bits
    BEQ @pauseLoop

    LDX #$00 ; i'm not blowing away anything?
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

resetHard:
    ; right idea, but I need to more gracefully restart
    ; maybe go back to the title screen?
    ; maybe break up the reset stuff up so i can resue it
    LDA #$00  ; disable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPU_CTRL_REG1
    STA PPU_CTRL_REG2

    JMP loadGameOver

gameMovement:
    JSR incTimerPowerUp

    JSR UpdatePositionPlayer      ; runs the player updates ;change this to update direction

    ; this should handle when to move the sprites
    JSR checkCollisionSprites ; I don't think I need this here

    ; skips over this section if we are resetting because of an out
    LDA gamePlayerReset
    BNE @dump

    JSR setAnimationPlayerDirection
    JSR checkCollisionPowerUp

    JSR nextEnemyMovement   ; move this to main?
    JSR checkCollisionSprites
    JSR checkDoor


    INC enemyMode

    JSR checkWin          ; maybe this sits well here?

@dump:
    RTS




