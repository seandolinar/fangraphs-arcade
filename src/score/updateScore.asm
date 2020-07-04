updateScore:

    TXA
    PHA

    ; alterative 0 + 12 becomes $12 divide by 
    CLC
    LDA scoreDigit0
    ADC scoreValue                ; this is where we are going to enter in the points we earn
    STA scoreDigit0
    CMP #$0a
    BCC @continueVram
    SBC #$0a
    STA scoreDigit0

    LDX #$00

    @loopDigit:
    CLC
    LDA scoreDigit1, X
    ADC #$01
    STA scoreDigit1, X

    CMP #$0a
    BNE @continueVram
    SBC #$0a
    STA scoreDigit1, X

    CPX #$02
    BEQ @continueVram
    INX
    JMP @loopDigit

    @continueVram:

    JSR startVramBuffer
    INY                                 ; increments it

    LDX #$00
    STX tempX1

    @loop:                              ; loop through the addresses
    ; hi                                ; hi, lo, value
    LDX tempX1
    LDA #$20
    STA (vram_lo), Y                    ; value should have the tile for the digit
    INY

    ; lo
    STX tempX1
    SEC
    LDA #$93
    SBC tempX1
    STA (vram_lo), Y

    ; value
    ; reads the digit
    LDX tempX1
    LDA scoreDigit0, X                  ; digits are indexed on 0
    STA scoreDigitBuffer

    INY

     ; X controls the digit
    LDX scoreDigitBuffer
    LDA NUM, X                          ; digit buffer is transformed into tile
    STA (vram_lo), Y

    LDX tempX1

    INX
    CPX #$08
    BEQ @dump
    INY

    STX tempX1

    JMP @loop

    @dump:
    STY vram_buffer_offset

    PLA
    TAX
    RTS
