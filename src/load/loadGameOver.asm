loadGameOver:


  LDA #%00010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA PPUState

  ;;; need to build this out for the pointer and stuff
  ;;; probably should just build out the compression here
  ;;; NAMETABLES
  LDA #<game_over_screen
  STA backgroundPointerLo
  LDA #>game_over_screen
  STA backgroundPointerHi

  JSR loadFullScreen

  ; RESETS
  LDA #$19
  STA bufferBackgroundColor

  LDA #$00
  ; STA inningDigit1
  ; STA inningDigit2
  STA scoreDigit0
  STA scoreDigit1
  STA scoreDigit2
  STA scoreDigit3
  ; STA scoreDigit4 ; why don't I have 4?
  STA scoreDigit5
  STA scoreDigit6
  STA scoreDigit7
  STA scoreDigit8


  LDA #$01
  STA inningDigit0

  JMP InitialLoad



loadWinScreen:

  ; ldx #FT_SFX_CH0
	; jsr FamiToneSfxPlay

      

  ; LDA #$03
	; JSR FamiToneMusicPlay

  ; Inning Digit Carrying Logic
  INC inning

  INC inningDigit0

  LDA inningDigit0
  CMP #$0a
  BNE @continueGameOver

  LDA #$00
  STA inningDigit0

  INC inningDigit1

  LDA inningDigit1
  CMP #$0a
  BNE @continueGameOver

  LDA #$00
  STA inningDigit1

  INC inningDigit2


  @continueGameOver:
  LDA #$00
  STA $2001

  LDA #%00010000   ; disables the NMI and puts the background into bank 1
  STA PPUState
  STA $2000

  LDA #<round_win_screen
  STA backgroundPointerLo
  LDA #>round_win_screen
  STA backgroundPointerHi



  JSR loadFullScreen

  ; how to get every 4? just divide by 4?
  ; how does 0 - 3 work 
  LDA inning
  AND #$03

  CMP #$01
  BEQ @board1
  CMP #$02
  BEQ @board2
  CMP #$03
  BEQ @board3

  STA $98

  ; GAME BOARD 0
  @board0:
  LDA #$00
  STA bufferBackgroundColor
  JMP @break

  @board1:
  LDA #$19
  STA bufferBackgroundColor
  JMP @break

  @board2:
  LDA #$14
  STA bufferBackgroundColor
  JMP @break

  @board3:
  LDA #$12
  STA bufferBackgroundColor


  @break:
  JMP InitialLoad

loadFullScreen:
  ; need this for the FillBackground subroutine
  LDA #<nametable_buffer
  STA nametable_buffer_lo
  LDA #>nametable_buffer
  STA nametable_buffer_hi

  JSR FillBackground


  ;; HAVE TO Reunderstand this
  ;; LOADING PALETTE
  LDA $2002    ; read PPU status to reset the high/low latch to high

  LDA #$3F
  STA $2006    ; write the high byte of $3F10 address
  LDA #$10
  STA $2006    ; write the low byte of $3F10 address


LDX #$00                ; start out at 0
@LoadPalettesLoop:
  LDA pallete_splash, X      ; load data from address (PaletteData + the value in x)
                          ; 1st time through loop it will load PaletteData+0
                          ; 2nd time through loop it will load PaletteData+1
                          ; 3rd time through loop it will load PaletteData+2
                          ; etc
  STA $2007               ; write to PPU
  INX                     ; X = X + 1
  CPX #$20               ; Compare X to hex $20, decimal 32
  BNE @LoadPalettesLoop 


; putting this after fixes things
@FillAttrib0:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address

  LDX #$00
@FillAttrib0Loop:
  ; LDA attribute_table, X
  LDA #$00
  STA $2007
  INX
  CPX #$40                   ; fill 64 bytes
  BNE @FillAttrib0Loop

  LDA #$1D
  STA bufferBackgroundColor

  LDA #$00
  STA $2005
  STA $2005

  LDA PPUState
  STA $2000

  LDA #%00001110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  @loop:

  JSR readController
  LDA controllerBits
  AND #CONTROL_P1_A

  BEQ @loop

  LDA #$00
	STA $2000               ; disable NMI
	STA $2001               ; disable rendering


  RTS
