.segment "CODE"
; SPRITE LOAD LOOP
InitialLoad:
  LoadSprites:
    LDX #$00              ; start at 0
  LoadSpritesLoop:
    LDA sprites, x        ; load data from address (sprites +  x)
    STA oam, x          ; store into RAM address ($0200 + x)
    INX                   ; X = X + 1
    CPX #$08           ; Compare X to hex $10, decimal 16
    BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero


;; HAVE TO Reunderstand this
;; LOADING PALETTE
LDA $2002    ; read PPU status to reset the high/low latch to high
LDA #$3F
STA $2006    ; write the high byte of $3F10 address
LDA #$10
STA $2006    ; write the low byte of $3F10 address


LDX #$00                ; start out at 0
LoadPalettesLoop:
  LDA pallete, X      ; load data from address (PaletteData + the value in x)
                          ; 1st time through loop it will load PaletteData+0
                          ; 2nd time through loop it will load PaletteData+1
                          ; 3rd time through loop it will load PaletteData+2
                          ; etc
  STA $2007               ; write to PPU
  INX                     ; X = X + 1
  CPX #$08               ; Compare X to hex $20, decimal 32
  BNE LoadPalettesLoop 


   ;INITIAL VARS
    LDA #$30
    STA playerLocationX
    STA playerLocationY


    ; STARTS VIDEO DISPLAY
    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000

    LDA #%00010110   ; enable sprites, enable background, no clipping on left side
    STA $2001


JMP Main