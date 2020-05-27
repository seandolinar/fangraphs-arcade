updateScore:

    TXA
    PHA

    ; how to get digits from a byte?
    ; do I have to do a bunch of cmp and subtractions?
    ; or loop division?
    ; use a lsr and divide by 5?
    ;128

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
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY vram_buffer_offset
    LDX #$00

    @loop:
   

    LDA #$20

    STA (vram_lo), Y

    INY

    ; might have to do math here
    SEC
    ; TXA
    ; ADC #$8D
    STX tempX
    LDA #$93
    SBC tempX
    STA (vram_lo), Y

    LDA scoreDigit0, X 
    STA scoreDigitBuffer

    TXA
    PHA
    INY

     ; X controls the digit
    LDX scoreDigitBuffer
    LDA NUM, X
    STA (vram_lo), Y

    PLA
    TAX
    INX
    CPX #$06
    BEQ @dump
    INY
    JMP @loop

    @dump:
    PLA
    TAX
    RTS


    ; move this
writeGameOver:
    ; abstract this
    ; do we need to find the last item in the buffer?
    ; or track that in another byte of RAM?
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    ; writes game over with letters
    ; i need the array of tiles
    ; i need the starting address (but that's low and high bytes)
    LDY #$01
    LDX #$00

    @loop:
    LDA #$20
    STA (vram_lo), Y

    INY

    ; might have to do math here
    CLC
    TXA
    ADC #$EC
    STA (vram_lo), Y

    INY

    LDA textGameOver, X
    STA (vram_lo), Y

    INX
    INY

    CPX #$09
    BNE @loop

    @dump:
    STY vram_buffer_offset
    RTS