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

  ; maybe rename this clearOutEnemySprites
  ; maybe move that subroutine
  JSR clearOutSprites


  ;;; need to build this out for the pointer and stuff
  ;;; probably should just build out the compression here
  ;;; NAMETABLES

  ; maybe unify our loads

  LDA inning
  AND #$03

  CMP #$01
  BEQ @board1
  CMP #$02
  BEQ @board2
  CMP #$03
  BEQ @board3

  LDA #<game_board0
  STA backgroundPointerLo
  LDA #>game_board0
  STA backgroundPointerHi

  JMP @continueBuffer

  @board1:
  LDA #<game_board1
  STA backgroundPointerLo
  LDA #>game_board1
  STA backgroundPointerHi

  JMP @continueBuffer

  @board2:
  LDA #<game_board2
  STA backgroundPointerLo
  LDA #>game_board2
  STA backgroundPointerHi

  JMP @continueBuffer

  @board3:
  LDA #<game_board3
  STA backgroundPointerLo
  LDA #>game_board3
  STA backgroundPointerHi

  JMP @continueBuffer

  @continueBuffer:
  LDA #<nametable_buffer
  STA nametable_buffer_lo
  LDA #>nametable_buffer
  STA nametable_buffer_hi

  JSR FillBackground


  ;; HAVE TO Reunderstand this
  ;; LOADING PALETTE
  LDA PPU_STATUS    ; read PPU status to reset the high/low latch to high

  LDA #$3F
  STA PPU_ADDRESS    ; write the high byte of $3F10 address
  LDA #$10
  STA PPU_ADDRESS    ; write the low byte of $3F10 address


  LDX #$00                ; start out at 0
  LoadPalettesLoop:
    LDA pallete, X      ; load data from address (PaletteData + the value in x)
                            ; 1st time through loop it will load PaletteData+0
                            ; 2nd time through loop it will load PaletteData+1
                            ; 3rd time through loop it will load PaletteData+2
                            ; etc
    STA PPU_DATA               ; write to PPU
    INX                     ; X = X + 1
    CPX #$20               ; Compare X to hex $20, decimal 32
    BNE LoadPalettesLoop 


; putting this after fixes things
FillAttrib0:
  LDA PPU_STATUS             ; read PPU status to reset the high/low latch
  LDA #$23
  STA PPU_ADDRESS             ; write the high byte of $23C0 address (nametable 0 attributes)
  LDA #$C0
  STA PPU_ADDRESS             ; write the low byte of $23C0 address

  LDX #$00            
FillAttrib0Loop:
  LDA attribute_table, X
  STA PPU_DATA
  INX
  CPX #$40                   ; fill 64 bytes
  BNE FillAttrib0Loop


  LDX $08
  @loopClearScore:
  LDA #$00
  STA scoreDigit0, X
  DEX
  CPX #$00
  BNE @loopClearScore


  ;CLEAR BUFFER
  JSR clearVRAMBuffer

  ;INITIAL VARS
  LDA #$00
  STA controllerTimer
  STA gameOuts

  JSR playerReset
  JSR enemyReset

  JSR updateScore

  ; Inning Writer
  JSR startVramBuffer

  @OnesPlace:
  INY                                 ; increments it
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  INY

  LDA #$d4
  STA (vram_lo), Y

  LDX #$00 ; 0 because I'm only do 1 digit right now
  LDA inningDigit0 , X                  ; digits are indexed on 0
  STA tempCatchAll

  INY
  LDX tempCatchAll    ; X controls the digit
  LDA NUM, X          ; digit buffer is transformed into tile
  STA (vram_lo), Y

  LDA inning
  CMP #$0a
  BCS @TensPlace

  JMP endInningUpdate

  @TensPlace:
  INY                                 ; increments it
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  INY

  LDA #$d3
  STA (vram_lo), Y

  LDX #$01 ; 0 because I'm only do 1 digit right now
  LDA inningDigit0 , X                  ; digits are indexed on 0
  STA tempCatchAll

  INY
  LDX tempCatchAll    ; X controls the digit
  LDA NUM, X          ; digit buffer is transformed into tile
  STA (vram_lo), Y

  LDA inning
  CMP #$64
  BCS @HundredsPlace

  JMP endInningUpdate

  @HundredsPlace:
  INY                                 ; increments it
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  INY

  ; SEC
  LDA #$d2
  STA (vram_lo), Y

  LDX #$02 ; 0 because I'm only do 1 digit right now
  LDA inningDigit0 , X                  ; digits are indexed on 0
  STA tempCatchAll

  INY
  LDX tempCatchAll    ; X controls the digit
  LDA NUM, X          ; digit buffer is transformed into tile
  STA (vram_lo), Y

  endInningUpdate:
  INY
  STY vram_buffer_offset

; initial parameters
; can make this into a looping array?
; it would save ROM code, but probably not cycles
LDA #$10
STA masterTimer

; debug == UNCOMMENT
; LDA #$01
; STA gameStateIsPowered


LDA #$00
STA gameStateIsPowered
STA gamePlayerReset
STA animationTimer

LDA #$02
STA enemyState
STA enemyState + 1
STA enemyState + 2
STA enemyState + 3

LDA #$01
STA powerUpAvailable ; first base power up is loaded first

LDA #$ff
STA isEnemyLeaving

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
        CPX #$05
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
  STA PPU_CTRL_REG1
  STA PPUState


  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA PPU_CTRL_REG2

  LDA #$00
  STA PPU_SCROLL_REG
  STA PPU_SCROLL_REG

  JMP Main



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