.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./position.asm"
.include "./enemy.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
.incbin "../chr/char01.chr"


.segment "CODE"
NMI:
    ; this interrupts the main loop

nmiSpriteTransfer:       
    ; SPRITE TRANSFER
    ; does this every frame
    LDA #$00
    STA $2003  ; set the low byte (00) of the RAM address
    LDA #>player_oam ; this works and so does $02
    STA $4014  ; set the high byte (02) of the RAM address, start the transfer

    JSR readController
    JSR incTimerPowerUp

    LDX masterTimer
    DEX
    STX masterTimer
    BNE dumpNMI
    JSR nextEnemyMovement ; move this to main?
    LDX #$10
    STX masterTimer

    
dumpNMI:
    RTI

IRQ:
    RTI

Main:
    JSR checkCollisionPowerUp
    JSR checkCollisionSprites


; ???




MainReadController:
    LDA controllerBits
    BEQ Main                ; go loop main if we have no controller bits
    JSR updatePosition      ; runs the player updates
    JMP Main                ; loops because of end


