

; player sprite
sprites:
.byte $b0, $12, %00000000, $80  ;$0200-3 ;; human player
.byte $b8, $22, %00000000, $80  ;$0200-3 ;; human player
.byte $b0, $13, %00000000, $88  ;$0200-3 ;; human player
.byte $b8, $23, %00000000, $88  ;$0200-3 ;; human player

; this is not RAM, huh?
enemy_array:
.byte $58, $01, %00000001, $A8 ;80 ; first enemy (O)
.byte $50, $01, %00000001, $80 ; second enemy (X)
.byte $30, $01, %00000001, $80 ; second enemy (X)
.byte $40, $01, %00000001, $80 ; second enemy (X)

; power ups
; FIRST BASE
.byte $5C, $25, %00000010, $E4
.byte $64, $25, %10000010, $E4
.byte $5C, $25, %01000010, $EC
.byte $64, $25, %11000010, $EC

; SECOND BASE 
.byte $0C, $25, %00000010, $7C
.byte $14, $25, %10000010, $7C
.byte $0C, $25, %01000010, $84
.byte $14, $25, %11000010, $84

; THIRD BASE
.byte $5C, $25, %00000010, $0C
.byte $64, $25, %10000010, $0C
.byte $5C, $25, %01000010, $14
.byte $64, $25, %11000010, $14

; HOME PLATE
.byte $CC, $14, %00000010, $7C
.byte $D4, $24, %00000010, $7C
.byte $CC, $14, %01000010, $84
.byte $D4, $24, %01000010, $84





meta_tile0:
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   
.byte $01, $0d, $05, $05, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $05,    $05, $05, $05, $05, $05, $05, $05, $05,    $05, $05, $05, $05, $05, $05, $0c, $01   
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $07, $04, $1f, $06, $06, $06, $06,   $06, $06, $06, $06, $06, $06, $06, $0f,    $03, $1f, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $0d, $05, $05, $05, $05, $05,    $05, $05, $0c, $05, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $03,    $03, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $1f, $06, $06, $06,    $0f, $03, $0a, $05, $09, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $02, $02, $02,    $07, $03, $03, $03, $03, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $0a, $05, $05, $05,    $09, $03, $1f, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $03,    $03, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $1f, $06, $06, $06,    $0f, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $0a, $09, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,   $03, $03, $03, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $1f, $0f, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $02, $02, $02,    $07, $03, $08, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $0d, $05, $05,    $09, $03, $0a, $05, $09, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $18, $17, $03, $03,    $03, $03, $03, $03, $03, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $1f,    $06, $06, $06, $06, $0f, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $1f, $0f, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $07, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $08, $07, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $18, $17, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $07, $03, $03, $03, $03, $08,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $08, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $07,    $03, $08, $0b, $06, $06, $06, $06, $0e,    $02, $02, $02, $02, $07, $04, $08, $01
.byte $01, $07, $04, $0a, $05, $05, $05, $05,   $05, $05, $05, $05, $05, $05, $05, $09,    $03, $0a, $05, $05, $05, $05, $05, $05,    $05, $05, $05, $05, $09, $04, $08, $01
.byte $01, $07, $04, $04, $04, $04, $04, $04,   $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $04, $04,    $04, $04, $04, $04, $04, $04, $08, $01
.byte $01, $0b, $06, $06, $06, $06, $06, $06,   $06, $06, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $06, $06, $06, $06,    $06, $06, $06, $06, $06, $06, $0e, $01
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   


.byte $ff