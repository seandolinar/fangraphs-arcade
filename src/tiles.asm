; player sprite
sprites:
.byte $b0, $12, %00000000, $80  ; TOP LEFT 0-4 
.byte $b8, $22, %00000000, $80  ; BOTTOM LEFT 5-8
.byte $b0, $13, %00000000, $88  ; TOP RIGHT 9-12
.byte $b8, $23, %00000000, $88  ; BOTTOM RIGHT 13-6

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

; HOME PLATE
.byte $CC, $14, %00000010, $7C
.byte $D4, $24, %00000010, $7C
.byte $CC, $14, %01000010, $84
.byte $D4, $24, %01000010, $84

tilesDots:
.byte $03, $04, $28, $48, $3a, $3c

meta_tile0:
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   
.byte $01, $0d, $05, $05, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $05,    $2b, $05, $05, $05, $05, $05, $05, $05,    $05, $05, $05, $05, $05, $05, $0c, $01   
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $3a,    $3b, $3c, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $07, $04, $1f, $06, $06, $06, $06,   $06, $0f, $03, $1f, $06, $06, $06, $06,    $4b, $06, $06, $06, $06, $0f, $03, $1f,    $06, $06, $06, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $05, $05, $0d, $05,   $05, $09, $03, $08, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $07, $03, $0a,    $05, $05, $0c, $05, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $07, $03,   $03, $03, $03, $08, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $07, $03, $03,    $03, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $0a, $05, $05, $09, $03,   $1f, $0f, $03, $08, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $07, $03, $1f,    $0f, $03, $0a, $05, $09, $04, $08, $01
.byte $01, $07, $04, $03, $03, $03, $03, $03,   $08, $07, $03, $08, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $07, $03, $08,    $07, $03, $03, $03, $03, $04, $08, $01
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
.byte $01, $07, $04, $0a, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $09,    $03, $0a, $05, $05, $05, $09, $03, $0a,    $05, $05, $05, $05, $09, $04, $08, $01
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $0b, $06, $06, $06, $06, $06, $06,   $06, $06, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $06, $06, $0e, $01
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   


.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; hacky fix for accidentally overfilling the buff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; I need to think about how to do that without 
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff ; taking up more space
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
.byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff