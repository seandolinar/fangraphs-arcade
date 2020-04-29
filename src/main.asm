.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
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
    JSR nmiMovement

dumpNMI:
    RTI

IRQ:
    RTI

; we are updating the position in MAIN
; but checking the position in NMI
Main:
    LDA controllerBits
    BEQ Main                ; go loop main if we have no controller bits
    JSR updatePosition      ; runs the player updates ;change this to update direction
    JMP Main                ; loops because of end

nmiMovement:

    JSR readController
    JSR incTimerPowerUp

    LDX masterTimer
    DEX
    STX masterTimer
    BNE @dump
    ; this should handle when to move the sprites
    JSR checkCollisionSprites ; this isn't working
    JSR dumpUpdatePosition
    JSR checkCollisionSprites ; this isn't working
    JSR checkCollisionPowerUp
    JSR countDots
    JSR nextEnemyMovement   ; move this to main?
    JSR checkCollisionSprites ; this isn't working


    LDX #$08                ; controls the speed of the game
    STX masterTimer
@dump:
    RTS