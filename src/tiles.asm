; player sprite
sprites:
.byte $c0, $12, %00000000, $80  ; TOP LEFT 0-4 
.byte $c8, $22, %00000000, $80  ; BOTTOM LEFT 5-8
.byte $c0, $13, %00000000, $88  ; TOP RIGHT 9-12
.byte $c8, $23, %00000000, $88  ; BOTTOM RIGHT 13-6

; this is not RAM, huh?
enemy_array:
.byte $58, $30, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $31, %00000010, $A8 ;80 ; first enemy (O)
.byte $58, $40, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $41, %00000010, $B0 ;80 ; first enemy (O)

.byte $58, $30, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $31, %00000010, $A8 ;80 ; first enemy (O)
.byte $58, $40, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $41, %00000010, $B0 ;80 ; first enemy (O)

.byte $58, $30, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $31, %00000010, $A8 ;80 ; first enemy (O)
.byte $58, $40, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $41, %00000010, $B0 ;80 ; first enemy (O)

.byte $58, $30, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $31, %00000010, $A8 ;80 ; first enemy (O)
.byte $58, $40, %00000010, $A8 ;80 ; first enemy (O)
.byte $60, $41, %00000010, $B0 ;80 ; first enemy (O)

tilesDots:
.byte $03, $04, $28, $48, $3a, $3c

tilesBases:
.byte $28, $38, $48, $3a, $3b, $3c, $2d, $2e, $2f, $3e

textGameOver:
.byte $d6, $d0, $dc, $d4, $36, $de, $e5, $d4, $e1 ; d6

; move this?
NUM:
.byte $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9

game_board0:
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   
.byte $01, $0d, $05, $05, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $05,    $2b, $05, $05, $05, $05, $05, $05, $05,    $05, $05, $05, $05, $05, $05, $0c, $01   
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $3a,    $3b, $3c, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $07, $04, $1f, $06, $06, $06, $06,   $06, $0f, $03, $1f, $06, $06, $06, $06,    $4b, $06, $06, $06, $06, $0f, $03, $1f,    $06, $06, $06, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $05, $05, $0d, $05,   $05, $09, $03, $08, $36, $36, __0, __0,    __0, __0, __0, __0, __0, $07, $03, $0a,    $05, $05, $0c, $05, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $03, $03, $03, $08, $36, $36, $36, $36,    $36, $36, $36, $36, $36, $07, $03, $03,    $03, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $0a, $05, $05, $09, $03,   $1f, $0f, $03, $08, $36, $36, $36, $36,    $36, $36, $36, $36, $36, $07, $03, $1f,    $0f, $03, $0a, $05, $09, $04, $08, $01
.byte $01, $07, $04, $03, $03, $03, $03, $03,   $08, $07, $03, $08, $36, __O, __U, __T,    __S, $36, $36, $36, $36, $07, $03, $08,    $07, $03, $03, $03, $03, $04, $08, $01
.byte $01, $07, $04, $1f, $06, $06, $0f, $03,   $18, $17, $03, $0a, $05, $05, $05, $05,    $05, $05, $05, $05, $05, $09, $03, $18,    $17, $03, $1f, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $03, $03, $03, $03, $03, $03, $03, $03,    $03, $03, $03, $03, $03, $03, $03, $03,    $03, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $1f, $06, $06, $06, $0f, $03, $1f, $0f,    $03, $1f, $0f, $03, $1f, $06, $06, $06,    $0f, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $28, $08, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $08, $07,    $03, $08, $07, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $28, $08, $01
.byte $01, $37, $38, $39, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $08, $07,    $03, $0a, $09, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $37, $38, $39, $01
.byte $01, $07, $48, $08, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $08, $07,    $03, $03, $03, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $48, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $08, $07,    $03, $1f, $0f, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $0a, $09,    $03, $08, $07, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $08, $02, $02, $02, $07, $03, $03, $03,    $03, $08, $07, $03, $08, $0d, $05, $05,    $09, $03, $0a, $05, $09, $04, $08, $01
.byte $01, $07, $04, $0a, $05, $05, $09, $03,   $08, $02, $02, $02, $0b, $06, $06, $0f,    $03, $08, $07, $03, $18, $17, $03, $03,    $03, $03, $03, $03, $03, $04, $08, $01
.byte $01, $07, $04, $03, $03, $03, $03, $03,   $08, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $1f,    $06, $06, $06, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $1f, $06, $06, $06, $06,   $0e, $02, $02, $02, $02, $02, $02, $07,    $03, $0a, $09, $03, $1f, $0f, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $03, $03, $03, $08, $07, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $1f, $0f, $03, $08, $07, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $18, $17, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $0b, $06, $06, $0f, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $0a, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $09,    $2e, $0a, $05, $05, $05, $09, $03, $0a,    $05, $05, $05, $05, $09, $04, $08, $01
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $2d,    $3e, $2f, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $0b, $06, $06, $06, $06, $06, $06,   $06, $06, $06, $06, $06, $06, $06, $06,    $4e, $06, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $06, $06, $0e, $01
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   


.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; hacky fix for accidentally overfilling the buff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; I need to think about how to do that without 
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; taking up more space
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff



splash_screen:
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $00, $01, $02, $03, $04, $05, $06,   $07, $08, $09, $0a, $0b, $0c, $0d, $0e,    $40, $41, $42, $43, $44, $45, $46, $47,    $48, $49, $4a, $4b, $4c, $4d, $4e, $ff   
.byte $ff, $10, $11, $12, $13, $14, $15, $16,   $17, $18, $19, $1a, $1b, $1c, $1d, $1e,    $50, $51, $52, $53, $54, $55, $56, $57,    $58, $59, $5a, $5b, $5c, $5d, $5e, $ff   
.byte $ff, $20, $21, $22, $23, $24, $25, $26,   $27, $28, $29, $2a, $2b, $2c, $2d, $2e,    $60, $61, $62, $63, $64, $65, $66, $67,    $68, $69, $6a, $6b, $6c, $6d, $6e, $ff   
.byte $ff, $30, $31, $32, $33, $34, $35, $36,   $37, $38, $39, $3a, $3b, $3c, $3d, $3e,    $70, $71, $72, $73, $74, $75, $76, $77,    $78, $79, $7a, $7b, $7c, $7d, $7e, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff   



.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; hacky fix for accidentally overfilling the buff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; I need to think about how to do that without 
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; taking up more space
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff