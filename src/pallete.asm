.segment "ROMDATA"

pallete:
; sprite - 2 - this is the ump after being eaten
.byte $0F,$0F,$20,$20,  $16,$22,$0F,$0F,  $35,$1D,$21,$37,  $35,$16,$30,$38  ; bank 0 ;; SPRITE BANK
.byte $19,$0F,$17,$20,  $0F,$0F,$28,$03,  $0F,$0F,$17,$28,  $0F,$0F,$17,$17   ; bank 1 ;; BACKGROUND BANK



pallete_splash:
; sprite - 2 - this is the ump after being eaten
.byte $0F,$0F,$20,$20,  $16,$22,$0F,$0F,  $35,$1D,$21,$37,  $35,$28,$30,$38  ; bank 0 ;; SPRITE BANK
.byte $0F,$0F,$20,$19,  $0F,$0F,$28,$03,  $0F,$0F,$17,$28,  $0F,$0F,$17,$17   ; bank 1 ;; BACKGROUND BANK


attribute_table:
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, %01000100, %01010101, %01010101, %00010001, $00, $00
.byte $00, $00, %00000100, %00000101, %00000101, %00000001, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00



