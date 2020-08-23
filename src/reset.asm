.segment "CODE"
RESET:
  SEI
  LDA #%00010000
  STA PPUState
	STA PPU_CTRL_REG1 ; disable NMI
  LDA #$00
	STA $2001 ; disable rendering
	STA $4010 ; disable DMC IRQ
	CLD       ; disable decimal mode
	LDX #$ff
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
  LDA #$fe
  STA $0200, X
  INX
  BNE ClearMemory

  WarmUp:
      BIT PPU_STATUS
  BPL WarmUp

  JSR clearOutSprites
  JSR clearOutSpritesPlayer

  LDA #$01
  STA inning
  STA inningDigit0

  LDA #$00
  STA controllerBits
  STA controllerBitsPrev
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
  STA gameOuts
  STA gamePlayerReset
  STA konamiCode
  STA hasCheated

  LDA #$19
  STA bufferBackgroundColor

  ldx #<fg_arcade_music_music_data	  ; set the music data location
	ldy #>fg_arcade_music_music_data
	lda #$0f                            ; NTSC_MODE
	jsr FamiToneInit		                ; init FamiTone

  lda #$00                            ; plays the take me out to the ball game song
	jsr FamiToneMusicPlay 

  ldx #<sounds			                  ; set sound effects data location
	ldy #>sounds
	jsr FamiToneSfxInit

  LDA #%10010000  
  STA PPU_CTRL_REG1
  STA PPUState

  JMP loadSplashScreen
