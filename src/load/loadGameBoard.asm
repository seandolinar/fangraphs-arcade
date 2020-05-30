.segment "CODE"
InitialLoad:
  LoadSprites:
    LDX #$00              ; start at 0
  @LoadSpritesLoop:
    LDA sprites, X        ; load data from address (sprites +  x)
    STA player_oam, X          ; store into RAM address ($0200 + x)
    
    INX   

    CPX #$10               ; Compare X to hex $10, decimal 16
    BNE @LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero


; maybe consolidate all of this
; CPX #$0c means we'll loop through a 3 different spirtes
  LoadEnemy:
    LDX #$00
  LoadEnemyLoop:
    LDA enemy_array, X       ; load data from address (sprites +  x) ; Y    
    STA enemy_oam , X          ; store into RAM address ($0200 + x)

    LDA enemy_array + 1, X        ; load data from address (sprites +  x) ; TILE
    STA enemy_oam + 1 , X         ; store into RAM address ($0200 + x)

    LDA enemy_array + 2, X        ; load data from address (sprites +  x) ; ATTR
    STA enemy_oam + 2, X         ; store into RAM address ($0200 + x)

    LDA enemy_array+3, X
    STA enemy_oam+3, X              ; X = X + 1 ; X

    INX
    INX
    INX
    INX
    
    CPX #$40
    BNE LoadEnemyLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero



  ;;; need to build this out for the pointer and stuff
  ;;; probably should just build out the compression here
  ;;; NAMETABLES
  ; LDA #<game_board0

  LDA #<game_board0
  STA backgroundPointerLo
  LDA #>game_board0
  STA backgroundPointerHi

  LDA #<nametable_buffer
  STA nametable_buffer_lo
  LDA #>nametable_buffer
  STA nametable_buffer_hi

  JSR FillBackground


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
  CPX #$20               ; Compare X to hex $20, decimal 32
  BNE LoadPalettesLoop 


; putting this after fixes things
FillAttrib0:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$23
  STA $2006             ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA $2006             ; write the low byte of $23C0 address

  LDX #$00            
  ; LDA #%11111101
  ; LDA #%11101111
  ; LDA #$00
FillAttrib0Loop:
  LDA attribute_table, X
  STA $2007
  INX
  CPX #$40                   ; fill 64 bytes
  BNE FillAttrib0Loop




  ;CLEAR BUFFER
  JSR clearVRAMBuffer


  ;INITIAL VARS
  LDA #$00
  STA controllerTimer
  STA gameOuts

  JSR playerReset
  JSR enemyReset

; initial parameters
; can make this into a looping array?
; it would save ROM code, but probably not cycles
LDA #$10
STA masterTimer

LDA #$E8
STA powerUpX
LDA #$60
STA powerUpY

LDA #$80
STA powerUpX2
LDA #$10
STA powerUpY2


LDA #$10
STA powerUpX3
LDA #$60
STA powerUpY3


LDA #$80
STA powerUpX4
LDA #$D0
STA powerUpY4

LDA #$00
STA gameStateIsPowered
STA gamePlayerReset

LDA #$01
STA powerUpAvailable ; first base power up is loaded first

LDA #$19
STA bufferBackgroundColor

countDots:

    LDA #<nametable_buffer
    STA nametable_buffer_lo
    LDA #>nametable_buffer
    STA nametable_buffer_hi

    LDX #$00
    STX dotsLeft      
    countDotsLoopOuter:   
    countDotsLoopInner:
        LDA (nametable_buffer_lo), Y 
        STX tempX                     ; stash X

        LDX #$00
        @loopCompareTilesDots:
        CMP tilesDots, X
        BEQ @incDotCount
        INX
        CPX #$06
        BNE @loopCompareTilesDots
       
        LDX tempX                     ; unstash X
        JMP countDotsNoInc

        @incDotCount:
        LDX tempX                     ; unstash X
        INC dotsLeft

        countDotsNoInc:
            INY                 ; inside loop counter
            CPY #$00            ; run the inside loop 256 times before continuing down
            BNE countDotsLoopInner 
            INC nametable_buffer_hi 
            INX
            CPX #$04
            BNE countDotsLoopInner 
   
  ; STARTS VIDEO DISPLAY
  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000
  STA PPUCopy


  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

  LDA #$00
  STA $2005
  STA $2005

  ; JSR InitMusic

JMP Main




; might have to figure out what i'm doing here
; took this from a sample program
; this part is messing up sprites
; InitMusic:

; 	lda #$00
; 	ldx #$00
; Clear_Sound:
; 	sta $4000,x
; 	inx
; 	cpx #$0F
; 	bne Clear_Sound

; 	lda #$10
; 	sta $4010
; 	lda #$00
; 	sta $4011
; 	sta $4012
; 	STA $4013

; 	lda #%00001111
; 	STA $4015

; 	lda #$C0
; 	STA $4017

; 	LDA #$00		; song number
; 	ldx #$00		; 00 for NTSC or $01 for PAL
; 	jsr $8000

;   RTS


FillBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address (nametable 0)
  LDA #$00
  STA $2006             ; write the low byte of $2000 address

  LDX #$00
  LDY #$00         
  @loop:
    LDA (backgroundPointerLo), Y
    STA $2007
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