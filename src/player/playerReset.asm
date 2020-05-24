playerReset:
  LDA #$90
  STA playerLocationX
  STA playerLocationXBuffer

  LDA #$d0
  STA playerLocationY
  STA playerLocationYBuffer

  RTS

renderOuts:
  
  RTS  