splashScreen:


  LDA #$1D
  STA bufferBackgroundColor


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

  LDA #<splash_screen
  STA backgroundPointerLo
  LDA #>splash_screen
  STA backgroundPointerHi

  LDA #<nametable_buffer
  STA nametable_buffer_lo
  LDA #>nametable_buffer
  STA nametable_buffer_hi

  JSR FillBackground


  @FillAttrib0:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address

  LDX #$00            
  ; LDA #%11111101
  ; LDA #%11101111
  ; LDA #$00
@FillAttrib0Loop:
  ; LDA attribute_table, X
  LDA #$00
  STA $2007
  INX
  CPX #$40                   ; fill 64 bytes
  BNE @FillAttrib0Loop


  LDA #%10011000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  LDA #$00
  STA $2005
  STA $2005

  @loop:

  JSR readController
  LDA controllerBits
  AND #CONTROL_P1_A

  BEQ @loop

  @break:

  LDA #$00   
  STA $2000
  STA $2001

  JMP InitialLoad
