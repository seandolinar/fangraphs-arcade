playerReset:
  LDA #$90
  STA playerLocationX
  STA playerLocationXBuffer

  LDA #$d0
  STA playerLocationY
  STA playerLocationYBuffer

  LDA #$00
  STA playerDirectionCurrent


  RTS

renderOuts:
  
  RTS  