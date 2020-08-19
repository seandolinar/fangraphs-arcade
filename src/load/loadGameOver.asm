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

  LDA #$01
  STA inningDigit0
  STA inning

  JMP InitialLoad



