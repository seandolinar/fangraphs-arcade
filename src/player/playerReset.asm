resetPlayerReset:
  LDA #$80
  STA playerLocationX
  STA playerLocationXBuffer

  LDA #$b0
  STA playerLocationY
  STA playerLocationYBuffer

  RTS


renderOuts:
  
  RTS  