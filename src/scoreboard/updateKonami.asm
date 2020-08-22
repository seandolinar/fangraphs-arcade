 labelKonami:
 .byte __C, __H, __E, __A, __T

 updateKonami:
  TXA
  PHA
  LDX #$00

  JSR startVramBuffer

  @loop:
  INY                                 ; increments it
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  
  INY
  CLC
  TXA
  ADC #$ae
  STA (vram_lo), Y

  INY
  LDA labelKonami, X
  STA (vram_lo), Y

  INX

  CPX #$05
  BEQ @break
  JMP @loop

  @break:
  STY vram_buffer_offset

  PLA
  TAX
  RTS