.segment "ROMDATA"

pallete:

.byte $0F,$2a,$1A,$56,  $16,$22,$17,$0F,  $35,$28,$30,$38,  $35,$28,$30,$38  ; bank 0 ;; SPRITE BANK
.byte $0F,$01,$36,$1c,  $16,$01,$17,$17,  $16,$01,$17,$28,  $16,$01,$17,$17   ; bank 1 ;; BACKGROUND BANK


sprites:
.byte $80, $00, %00000000, $80  ;$0200-3 ;; human player
; .byte $88, $01, %00000001, $80  ;$0204-7 ;; no
; .byte $40, $01, %00000001, $40  ;$0208-b? ;; no ;; what are these?

background_item:
.byte $01, $01, $00, $00, $00, $01

