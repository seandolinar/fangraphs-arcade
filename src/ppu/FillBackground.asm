FillBackground:
  ; LDA PPU_STATUS           ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPU_ADDRESS             ; write the high byte of $2000 address (nametable 0)
  LDA #$00
  STA PPU_ADDRESS             ; write the low byte of $2000 address

  LDX #$00
  LDY #$00         
  @loop:
    LDA (backgroundPointerLo), Y
    STA PPU_DATA
    STA (nametable_buffer_lo), Y ; not working

    INY                 ; inside loop counter
    CPY #$00            ; run the inside loop 256 times before continuing down
    BNE @loop 
    INC backgroundPointerHi
    INC nametable_buffer_hi 
    INX
    CPX #$04
    BNE @loop 

  RTS