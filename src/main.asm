.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
.include "./player/playerAnimation.asm"
.include "./enemy/enemy.asm"
.include "./enemy/enemyAI.asm"
.include "./enemy/enemyCollision.asm"
.include "./enemy/enemyPowerUp.asm"
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


.segment "CODE"
NMI:
    ; this interrupts the main loop

; vBlankWait:	
@vBlankLoop:
	lda $2002   
    bpl @vBlankLoop

    JSR changeBackground
    JSR spriteTransfer

    LDX masterTimer
    DEX
    STX masterTimer
   
@dumpNMI:
    RTI

; @resetTimer:
;     LDX #$08                ; controls the speed of the game
;     STX masterTimer
;     RTI

IRQ:
    RTI

; we are updating the position in MAIN
; but checking the position in NMI
Main:
    ; LDA controllerBits
    ; BEQ @exit               ; go loop main if we have no controller bits
    ; should check to see if controller Bits changed
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


    JSR checkWin          ; maybe this sits well here?

@dump:
    RTS