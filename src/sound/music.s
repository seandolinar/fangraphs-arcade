;this file for FamiTone2 library generated by FamiStudio

untitled_music_data:
	.byte 2
	.word @instruments
	.word @samples-3
	.word @song0ch0,@song0ch1,@song0ch2,@song0ch3,@song0ch4,307,256
	.word @song1ch0,@song1ch1,@song1ch2,@song1ch3,@song1ch4,307,256

@instruments:
	.byte $b0 ;instrument 00 (GameBoard)
	.word @env1, @env0, @env0
	.byte $00
	.byte $f0 ;instrument 01 (Harmony)
	.word @env1, @env0, @env0
	.byte $00
	.byte $b0 ;instrument 02 (Main)
	.word @env1, @env0, @env0
	.byte $00

@samples:
@env0:
	.byte $c0,$7f,$00,$00
@env1:
	.byte $cf,$7d,$cf,$00,$02

@song0ch0:
	.byte $fb, $01
@song0ch0loop:
@ref0:
	.byte $f9,$f9,$f9,$c1
@ref1:
	.byte $f9,$f9,$f9,$c1
@ref2:
	.byte $f9,$f9,$f9,$c1
@ref3:
	.byte $f9,$f9,$f9,$c1
@ref4:
	.byte $f9,$f9,$f9,$c1
@ref5:
	.byte $f9,$f9,$f9,$c1
@ref6:
	.byte $f9,$f9,$f9,$c1
@ref7:
	.byte $f9,$f9,$f9,$c1
	.byte $fd
	.word @song0ch0loop

@song0ch1:
@song0ch1loop:
@ref8:
	.byte $84,$3c,$c3,$54,$a3,$4e,$a3,$4a,$9d,$44,$a3,$4a,$e9,$40,$e7,$00
@ref9:
	.byte $3c,$c9,$54,$9f,$4e,$a1,$4a,$a1,$44,$9f,$4a,$f9,$db
@ref10:
	.byte $4e,$a1,$4c,$a5,$4e,$9d,$44,$a3,$46,$9d,$4a,$a5,$4e,$c5,$46,$a1,$40,$e7
@ref11:
	.byte $83,$4e,$bd,$00,$83,$4e,$9b,$00,$83,$4e,$9f,$52,$a1,$54,$9f,$58,$a5,$52,$a7,$4e,$99,$4e,$4a,$9f,$48,$a1,$44,$9f,$44
@ref12:
	.byte $3c,$c7,$52,$a1,$4e,$9f,$4a,$9f,$44,$a1,$4a,$eb,$40,$bf,$00,$83,$40,$a1
@ref13:
	.byte $3c,$c7,$40,$9d,$44,$a1,$46,$a1,$4a,$a3,$4e,$e7,$4e,$9b,$00,$83,$4e,$a5,$52,$9d,$52
@ref14:
	.byte $54,$df,$00,$85,$54,$e7,$01,$54,$9f,$52,$a3,$4e,$a1,$4a,$a1,$48,$a1,$4a,$a1
@ref15:
	.byte $4e,$e9,$52,$e7,$54,$f9,$db,$00
	.byte $fd
	.word @song0ch1loop

@song0ch2:
@song0ch2loop:
@ref16:
	.byte $81,$82,$3a,$e9,$4a,$e9,$40,$e7,$3c,$e9
@ref17:
	.byte $81,$3a,$e9,$4a,$e9,$40,$e7,$3c,$e9
@ref18:
	.byte $81,$4a,$e7,$40,$e9,$4a,$eb,$3c,$e7
@ref19:
	.byte $83,$4a,$f9,$d7,$54,$e7,$4a,$eb
@ref20:
	.byte $3a,$eb,$4a,$e7,$40,$eb,$3c,$e7
@ref21:
	.byte $81,$3a,$e9,$40,$e7,$4a,$e9,$4a,$e9
@ref22:
	.byte $4e,$f9,$d9,$4e,$ed,$40,$e7
@ref23:
	.byte $83,$44,$e5,$48,$e9,$4a,$f9,$d7,$00,$81
	.byte $fd
	.word @song0ch2loop

@song0ch3:
@song0ch3loop:
@ref24:
	.byte $f9,$f9,$f9,$c1
@ref25:
	.byte $f9,$f9,$f9,$c1
@ref26:
	.byte $f9,$f9,$f9,$c1
@ref27:
	.byte $f9,$f9,$f9,$c1
@ref28:
	.byte $f9,$f9,$f9,$c1
@ref29:
	.byte $f9,$f9,$f9,$c1
@ref30:
	.byte $f9,$f9,$f9,$c1
@ref31:
	.byte $f9,$f9,$f9,$c1
	.byte $fd
	.word @song0ch3loop

@song0ch4:
@song0ch4loop:
@ref32:
	.byte $f9,$f9,$f9,$c1
@ref33:
	.byte $f9,$f9,$f9,$c1
@ref34:
	.byte $f9,$f9,$f9,$c1
@ref35:
	.byte $f9,$f9,$f9,$c1
@ref36:
	.byte $f9,$f9,$f9,$c1
@ref37:
	.byte $f9,$f9,$f9,$c1
@ref38:
	.byte $f9,$f9,$f9,$c1
@ref39:
	.byte $f9,$f9,$f9,$c1
	.byte $fd
	.word @song0ch4loop

@song1ch0:
	.byte $fb, $01
@song1ch0loop:
@ref40:
	.byte $f9,$f9,$cb
	.byte $fd
	.word @song1ch0loop

@song1ch1:
@song1ch1loop:
@ref41:
	.byte $f9,$f9,$cb
	.byte $fd
	.word @song1ch1loop

@song1ch2:
@song1ch2loop:
@ref42:
	.byte $80,$54,$87,$62,$87,$38,$83,$40,$83,$48,$8d,$4e,$89,$48,$91,$56,$87,$62,$87,$38,$85,$40,$83,$82,$4a,$89,$4e,$8d,$56,$8f,$62,$91,$56,$91,$48,$9d,$38,$ad,$4a,$91,$4e,$8f,$00
	.byte $fd
	.word @song1ch2loop

@song1ch3:
@song1ch3loop:
@ref43:
	.byte $f9,$f9,$cb
	.byte $fd
	.word @song1ch3loop

@song1ch4:
@song1ch4loop:
@ref44:
	.byte $f9,$f9,$cb
	.byte $fd
	.word @song1ch4loop
