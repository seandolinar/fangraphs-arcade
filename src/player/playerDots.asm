; CONTAINS ALL LOGIC FOR eating dots

collideDot:

    JSR soundDot
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

    LDA #$02
    STA bufferBackgroundTile

    LDA (bufferBackgroundValLo), Y
    CMP #$04
    BNE @continueTileNotBrown

    LDA #$34
    STA bufferBackgroundTile

    @continueTileNotBrown:
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