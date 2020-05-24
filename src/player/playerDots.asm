; CONTAINS ALL LOGIC FOR eating dots

checkCollideDot:
    
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
    RTS


collideDot:

    JSR soundDot
    JSR updateScore

    DEC dotsLeft

    ; add to $2000
    ; finds the address for the name table
    STY tempY
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

    LDY tempY

    RTS


; not sure why we are putting this here
checkWin:
    LDA dotsLeft
    BNE @exit
    LDA powerUpAvailable
    CMP #$05
    BNE @exit

    ; WIN color
    LDA #$04
    STA bufferBackgroundColor

    @exit:
    RTS