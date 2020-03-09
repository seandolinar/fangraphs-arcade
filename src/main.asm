.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./position.asm"
.include "./enemy.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
;.incbin "../chr/mario.chr"
.incbin "../chr/char01.chr"


.segment "CODE"
NMI:
 ; this runs during the main loop
          
  ; SPRITE TRANSFER
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #>player_oam ; this works and so does $02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  JSR readController

    LDX masterTimer
    DEX
    STX masterTimer
    BEQ dumpNMI
    JSR nextEnemyMovement


dumpNMI:
    RTI

IRQ:
    RTI

Main:

 

MainReadController:
    LDA controllerBits
    BEQ Main                ; go loop main if we have no controller bits
    JSR updatePosition      ; runs the player updates
    JMP Main                ; loops because of end

