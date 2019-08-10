.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
;.incbin "../chr/mario.chr"
.incbin "../chr/char01.chr"


.segment "CODE"
NMI:
  JSR readController

  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #>oam ; this works and so does $02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer

  LDA controllerBits
  AND #%00000001
  BEQ dumpNMI

  LDA #$10
  STA $0200


  dumpNMI:

    RTI

IRQ:
    RTI

Main:

    JMP Main

