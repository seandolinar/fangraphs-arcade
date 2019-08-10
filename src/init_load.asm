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


    ; STARTS VIDEO DISPLAY
    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000

    LDA #%00010110   ; enable sprites, enable background, no clipping on left side
    STA $2001


JMP Main