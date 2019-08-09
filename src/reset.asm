.segment "CODE"
RESET:
    SEI
    LDA #$00
	STA $2000 ; disable NMI
	STA $2001 ; disable rendering
	STA $4015 ; disable APU sound
	STA $4010 ; disable DMC IRQ