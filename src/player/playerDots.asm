; CONTAINS ALL LOGIC FOR eating dots
collideDot:

    JSR soundDot

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




countDots:

    LDA #<nametable_buffer
    STA nametable_buffer_lo
    LDA #>nametable_buffer
    STA nametable_buffer_hi



    LDX #$00
    LDY #$00
    STX dotsLeft      
    countDotsLoopOuter:   
    countDotsLoopInner:
        LDA (nametable_buffer_lo), Y ; not working

        CMP #$03
        BEQ @incDotCount
        CMP #$04
        BEQ @incDotCount
        ; STA consoleLog

        JMP countDotsNoInc


        @incDotCount:
        INC dotsLeft

        countDotsNoInc:
            INY                 ; inside loop counter
            CPY #$00            ; run the inside loop 256 times before continuing down
            BNE countDotsLoopInner 
            INC nametable_buffer_hi 
            INX
            CPX #$04
            BNE countDotsLoopInner 

    LDA dotsLeft
    BNE dumpCountDots
    LDA powerUpAvailable
    CMP #$05
    BNE dumpCountDots

    ; WIN color
    LDA #$16
    STA bufferBackgroundColor

dumpCountDots:
    RTS