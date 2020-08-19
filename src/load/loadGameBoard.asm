.segment "CODE"
loadGameBoard:
  LoadSprites:
    LDX #$00              ; start at 0
  @LoadSpritesLoop:
    LDA sprites, X        ; load data from address (sprites +  x)
    STA player_oam, X          ; store into RAM address ($0200 + x)
    
    INX   

    CPX #$10               ; Compare X to hex $10, decimal 16
    BNE @LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero

  JSR clearOutSprites


  ;;; NAMETABLES
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

  ; this is wrong
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

LDA #$10
STA masterTimer

; debug == UNCOMMENT
; LDA #$01
; STA gameStateIsPowered


LDA #$00
STA gameStateIsPowered
STA gamePlayerReset
STA animationTimer
STA powerUpTimer

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
    CLC    

    LDA #<nametable_buffer
    STA nametable_buffer_lo
    LDA #>nametable_buffer
    STA nametable_buffer_hi

    LDX #$00
    STX dotsLeft
    LDY #$00

    countDotsLoopOuter:   
    countDotsLoopInner:
        TXA
        PHA

        LDA (nametable_buffer_lo), Y

        LDX #$00
        @loopCompareTilesDots:
        CMP tilesDots, X
        BEQ @incDotCount

        CPX #$05
        BEQ @continueCount
        INX
        JMP @loopCompareTilesDots

        @continueCount:
        PLA
        TAX
        JMP countDotsNoInc

        @incDotCount:

        PLA
        TAX

        INC dotsLeft

        countDotsNoInc:
            INY                 ; inside loop counter
            CPY #$00            ; run the inside loop 256 times before continuing down
            BNE countDotsLoopInner 
            INC nametable_buffer_hi 
            INX
            CPX #$04
            BNE countDotsLoopInner 

  JSR updateInning

  ; wait for vblank to restart
  @vBlankLoop:
	  LDA PPU_STATUS   
    BPL @vBlankLoop

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

