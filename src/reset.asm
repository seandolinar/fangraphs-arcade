.segment "CODE"
RESET:
  SEI
  LDA #%00010000
  STA PPUState
	STA $2000 ; disable NMI
  LDA #$00
	STA $2001 ; disable rendering
	STA $4010 ; disable DMC IRQ
	CLD       ; disable decimal mode
	LDX #$FF
	TXS       ; initialize stack

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

  LDA #$01
  STA inning
  STA inningDigit0


  LDA #$00
  STA controllerBits
  STA inningDigit1
  STA inningDigit2
  STA scoreDigit0
  STA scoreDigit1
  STA scoreDigit2
  STA scoreDigit3
  STA scoreDigit4
  STA scoreDigit5
  STA scoreDigit6
  STA scoreDigit7
  STA scoreDigit8
  STA scoreDigit9
  STA scoreDigit10
  STA scoreDigit11

  STA scoreValue

  LDA #$19
  STA bufferBackgroundColor

  ldx #<fg_arcade_music_music_data	;initialize using the first song data, as it contains the DPCM sound effect
	ldy #>fg_arcade_music_music_data
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
