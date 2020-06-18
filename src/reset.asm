.segment "CODE"
RESET:
  SEI
  LDA #%00010000
  STA PPUState
	STA $2000 ; disable NMI
  LDA #$00
	STA $2001 ; disable rendering
	; STA $4015 ; disable APU sound
	STA $4010 ; disable DMC IRQ
  ; STA $4017 ; disable APU IRQ
	CLD       ; disable decimal mode
	LDX #$FF
	TXS       ; initialize stack

  ; ENABLE SOUND
  ; LDA #%00000001
  ; LDA $4015 ;enable square 1

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

     ; STARTS VIDEO DISPLAY
  ; LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  ; STA $2000 ;;;;; THIS WORKS!!! UGH
  ; STA PPUState ; need this state for the update to work on Nestopia


  LDA #$00
  STA controllerBits




  ldx #<untitled_music_data	;initialize using the first song data, as it contains the DPCM sound effect
	ldy #>untitled_music_data
	lda #$0F ;NTSC_MODE
	jsr FamiToneInit		;init FamiTone
  lda #$00
	jsr FamiToneMusicPlay

  ldx #<sounds			;set sound effects data location
	ldy #>sounds
	jsr FamiToneSfxInit

  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  STA PPUState

  JMP splashScreen
; JMP InitialLoad