.include "./header.asm"
.include "./res.asm"
.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
;.incbin "./chr/mario.chr"
.incbin "../chr/char01.chr"


.segment "CODE"
NMI:
    RTI

IRQ:
    RTI

Main:
    JMP Main