.segment "ROMDATA"

pallete:
.byte $22,$27,$1A,$56,  $22,$36,$17,$0F,  $35,$1d,$30,$19,  $22,$19,$17,$0F   ; bank 0
.byte $0F,$31,$36,$1c,  $22,$02,$38,$0C,  $22,$22,$22,$22,  $22,$02,$38,$3C  ; bank 1


sprites:
.byte $1f, $fc, %00000010, $80  ;$0200
.byte $2f, $86, $00, $10        ;$0204
.byte $2f, $86, $00, $10        ;$0208
.byte $2f, $86, $00, $10        ;$020b