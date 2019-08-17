.segment "CODE"
; SPRITE LOAD LOOP
InitialLoad:
  LoadSprites:
    LDX #$00              ; start at 0
  LoadSpritesLoop:
    LDA sprites, x        ; load data from address (sprites +  x)
    STA player_oam, x          ; store into RAM address ($0200 + x)
    INX                   ; X = X + 1
    CPX #$04           ; Compare X to hex $10, decimal 16
    BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero

  LoadEnemy:
    LDX #$00
  LoadEnemyLoop:
    LDA enemy_array, X       ; load data from address (sprites +  x)
    STA enemy_oam + 1, X          ; store into RAM address ($0200 + x)
    LDA enemy_array+1, X        ; load data from address (sprites +  x)
    STA enemy_oam , X         ; store into RAM address ($0200 + x)
    LDA enemy_array+2, X        ; load data from address (sprites +  x)
    STA enemy_oam+3 , X         ; store into RAM address ($0200 + x)
    LDA enemy_array+3, X
    STA enemy_oam+2, X              ; X = X + 1
    INX
    INX
    INX
    INX
    CPX #$10          ; Compare X to hex $10, decimal 16
    BNE LoadEnemyLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero



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



FillAttrib0:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$27
  STA $2006             ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address
  LDX #$40              ; fill 64 bytes
  LDA #$02
  ;LDA #%11101011
FillAttrib0Loop:
  STA $2007
  DEX
  BNE FillAttrib0Loop


;;; need to build this out for the pointer and stuff
;;; probably should just build out the compression here
FillBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address (nametable 0)
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
 
LDX #$00            
FillBackgroundLoop:
  LDA meta_tile0, X
  STA $2007
  INX
  ;CMP #$ff
  BEQ dumpFillBackground
  JMP FillBackgroundLoop

dumpFillBackground:


   ;INITIAL VARS
    LDA #$00
    STA controllerTimer


    LDA #$10
    STA playerLocationX
    STA playerLocationY

    LDA #$40
    STA enemyX
    STA enemyY
    
    LDA #$08
    STA enemyH
    STA enemyW
    ;STA enemy


    ; STARTS VIDEO DISPLAY
    LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000

    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA $2001

    LDA #$00
    STA $2005
    STA $2005

JMP Main



enemy_array:
.byte $01, $20, $18, $02
.byte $01, $28, $28, $03 
.byte $01, $30, $30, $01 
.byte $01, $50, $28, $01


meta_tile0:
.byte $01, $01, $01, $01, $01, $01, $01, $01,   $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01,    $01, $01, $01, $01, $01, $01, $01, $01   
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $01, $01, $01, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $01, $01, $01, $01, $01, $01,    $01, $02, $01, $01, $01, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $01, $02, $01, $01, $01, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $01, $02, $01, $01, $01, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $01, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $01, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $01, $01, $01, $01, $01, $01, $01, $01,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01
.byte $01, $01, $02, $02, $02, $02, $02, $02,   $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $02, $02,    $02, $02, $02, $02, $02, $02, $01, $01

.byte $ff