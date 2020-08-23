loadSplashScreen:
  ;;; NAMETABLES
  LDA #<splash_screen
  STA backgroundPointerLo
  LDA #>splash_screen
  STA backgroundPointerHi

  ; need this for the FillBackground subroutine
  LDA #<nametable_buffer
  STA nametable_buffer_lo
  LDA #>nametable_buffer
  STA nametable_buffer_hi

  JSR FillBackground

  ;; LOADING PALETTE
  LDA PPU_STATUS            ; read PPU status to reset the high/low latch to high

  LDA #$3F
  STA PPU_ADDRESS           ; write the high byte of $3F10 address
  LDA #$10
  STA PPU_ADDRESS           ; write the low byte of $3F10 address


  LDX #$00                  ; start out at 0
@LoadPalettesLoop:
  LDA pallete_splash, X     ; load data from address (PaletteData + the value in x)
                            ; 1st time through loop it will load PaletteData+0
                            ; 2nd time through loop it will load PaletteData+1
                            ; 3rd time through loop it will load PaletteData+2
                            ; etc
  STA PPU_DATA              ; write to PPU
  INX                    
  CPX #$20                  ; Compare X to hex $20, decimal 32
  BNE @LoadPalettesLoop 


@FillAttrib0:
  LDA PPU_STATUS             ; read PPU status to reset the high/low latch
  LDA #$23
  STA PPU_ADDRESS            ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA PPU_ADDRESS            ; write the low byte of $23C0 address

  LDX #$00
@FillAttrib0Loop:

  LDA #$00
  STA PPU_DATA
  INX
  CPX #$40                    ; fill 64 bytes
  BNE @FillAttrib0Loop

  LDA #$1D
  STA bufferBackgroundColor

  LDA #%00001110  
  STA PPU_CTRL_REG2

  LDA #$00
  STA PPU_SCROLL_REG
  STA PPU_SCROLL_REG

  LDA #$00
  STA controllerBits
  STA controllerBitsPrev
  @loop:
  JSR readController
  LDA controllerBits
  EOR controllerBitsPrev      ; difference in buttons
  AND controllerBits
  AND #CONTROL_P1_A
  BEQ @loop

  LDA #$19
  STA bufferBackgroundColor

  jsr FamiToneMusicStop		     ;stop music

  LDA #$00
	STA PPU_CTRL_REG1               ; disable NMI
	STA PPU_CTRL_REG2               ; disable rendering

  JMP loadGameBoard
