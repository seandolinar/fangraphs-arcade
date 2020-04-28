.segment "ROMDATA"

pallete:

.byte $0F,$2a,$1A,$56,  $16,$22,$17,$0F,  $35,$28,$30,$38,  $35,$28,$30,$38  ; bank 0 ;; SPRITE BANK
.byte $0F,$0F,$1a,$20,  $0F,$01,$17,$17,  $0F,$01,$17,$28,  $0F,$01,$17,$17   ; bank 1 ;; BACKGROUND BANK

; need to consolidate these
sprites:
.byte $b0, $00, %00000000, $80  ;$0200-3 ;; human player
.byte $b8, $00, %00000000, $80  ;$0200-3 ;; human player
.byte $b0, $00, %00000000, $88  ;$0200-3 ;; human player
.byte $b8, $00, %00000000, $88  ;$0200-3 ;; human player


background_item:
.byte $01, $01, $00, $00, $00, $01

