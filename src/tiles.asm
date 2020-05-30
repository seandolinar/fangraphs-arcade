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
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $00, $01, $02, $03,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $10, $11, $12, $13,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $20, $21, $22, $23,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $30, $31, $32, $33,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, __S, __E, __A, __N, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   
.byte $02, $02, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02   



.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; hacky fix for accidentally overfilling the buff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; I need to think about how to do that without 
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; taking up more space
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff