.segment "CODE"
RESET:
    SEI
    LDA #$00
	STA $2000 ; disable NMI
	STA $2001 ; disable rendering
	STA $4015 ; disable APU sound
	STA $4010 ; disable DMC IRQ
    STA $4017 ; disable APU IRQ
	CLD       ; disable decimal mode
	LDX #$FF
	TXS       ; initialize stack

; ENABLE SOUND
lda #%00000001
sta $4015 ;enable square 1

; CLEAR MEMORY
LDX $00
ClearMemory:
  LDA #$00
  STA $0000, X
  STA $0100, X
  STA $0300, X
  STA $0400, X
  STA $0500, X
  STA $0600, X
  STA $0700, X
  LDA #$FE
  STA $0200, X
  INX
  BNE ClearMemory

    WarmUp:
        BIT $2002
		BPL WarmUp


  LDA #$00
  STA controllerBits

  JMP splashScreen
;   JMP InitialLoad