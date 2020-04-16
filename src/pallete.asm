.segment "ROMDATA"

pallete:

; we are using bank 0 and the first item for the background ;; bank 0
; the second item in the second group is for the 0 enemy ;; bank 0
; the second item in the first group is for the X player ;; bank 0
.byte $0F,$2a,$1A,$56,  $16,$37,$17,$0F,  $35,$1e,$30,$19,  $22,$19,$17,$0F   ; bank 0 ;; SPRITE
.byte $0F,$16,$36,$1c,  $22,$19,$17,$0F,  $22,$19,$17,$0F,  $22,$19,$17,$0F   ; bank 1 ;; BACKGROUND


sprites:
.byte $80, $00, %00000000, $80  ;$0200
.byte $88, $01, %00000001, $80  ;$0204

background_item:
.byte $01, $01, $00, $00, $00, $01

