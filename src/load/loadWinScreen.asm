loadWinScreen:
  ; Inning Digit Carrying Logic
  INC inning

  CLC ; guards agaist overflow?

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

  ; wait for vblank to restart
  @vBlankLoop:
	LDA PPU_STATUS   
    BPL @vBlankLoop

  LDA #$00
  STA PPU_CTRL_REG2

  LDA #%00010000   ; disables the NMI and puts the background into bank 1
  STA PPUState
  STA PPU_CTRL_REG1

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
  JMP loadGameBoard