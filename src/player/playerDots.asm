; CONTAINS ALL LOGIC FOR eating dots

checkCollideDot:

    TXA
    PHA
    
    LDX #$00  
    LDA collisionBackgroundTile

    ; probably should refactor the loop 
    ; once I have more efficient methods understood better
    @loopCompareTilesDots:
    CMP tilesDots, X
    BEQ @collideDotBranch
    INX
    CPX #$06
    BNE @loopCompareTilesDots

    JMP @exit

    @collideDotBranch:
    JSR collideDot

    @exit:
    PLA
    TAX
    RTS


collideDot:

    JSR soundDot
    DEC dotsLeft

    TYA
    PHA
    LDY #$00

    ; could make this programatic, but it's hardcoded now
    CLC
    LDA playerPointerLo
    ADC #$00
    STA bufferBackgroundValLo

    LDA playerPointerHi
    ADC #$03                
    STA bufferBackgroundValHi

    ; default green tile
    LDA #$02
    STA bufferBackgroundTile

    LDA (bufferBackgroundValLo), Y
    CMP #$04
    BEQ @continueTileBrown

    CMP #$28
    BEQ @continueTileBaseUp

    CMP #$48
    BEQ @continueTileBaseDown

    CMP #$3a
    BEQ @continueTileBaseLeft

    CMP #$3c
    BEQ @continueTileBaseRight

    JMP @continueTile

    @continueTileBrown:
    ; brown tile
    LDA #$34
    STA bufferBackgroundTile
    JMP @continueTile

    @continueTileBaseUp:
    LDA #$27
    STA bufferBackgroundTile
    JMP @continueTile

    @continueTileBaseDown:
    LDA #$47
    STA bufferBackgroundTile
    JMP @continueTile

    @continueTileBaseLeft:
    LDA #$2a
    STA bufferBackgroundTile
    JMP @continueTile

    @continueTileBaseRight:
    LDA #$2c
    STA bufferBackgroundTile
    JMP @continueTile

    ; green tile
    @continueTile:
    ; this affects the RAM map of the background
    LDA #$02
    STA (bufferBackgroundValLo), Y

    CLC
    LDA playerPointerLo
    ADC #$00
    STA bufferBackgroundValLo

    LDA playerPointerHi
    ADC #$20
    STA bufferBackgroundValHi

    JSR startVramBuffer
    INY
    
    LDA bufferBackgroundValHi
    STA (vram_lo), Y

    INY
    LDA bufferBackgroundValLo
    STA (vram_lo), Y

    INY
    LDA bufferBackgroundTile
    STA (vram_lo), Y

    STY vram_buffer_offset

    PLA
    TAY

    LDA #$05
    STA scoreValue
    JSR updateScore

    RTS


; not sure why we are putting this here
checkWin:

    ; TODO:
    ; !!DEBUG
    ; JSR readController
    ; LDA controllerBits
    ; EOR controllerBitsPrev ; difference in buttons

    @skip:
    LDA dotsLeft
    BNE @exit
    LDA powerUpAvailable
    CMP #$ff
    BEQ @win
    CMP #$05
    BNE @exit

    LDA frameTimer
    ADC #$30
    STA frameDelay

    ; only works here if we have a good frame delay
    JSR soundNextInning

    @win:
    CLC
    LDA frameTimer
    CMP frameDelay
    BNE @win

    @continueWin:
    JSR FamiToneMusicStop		; stop music

    LDA #$00  ; disable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA konamiCode
    STA PPU_CTRL_REG1
    STA PPU_CTRL_REG2

    JMP loadWinScreen

    @exit:
    RTS