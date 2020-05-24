updateScore:

    ; how to get digits from a byte?
    ; do I have to do a bunch of cmp and subtractions?
    ; or loop division?
    ; use a lsr and divide by 5?
    ;128

    ; alterative 0 + 12 becomes $12 divide by 
    CLC
    LDA scoreDigit0
    ADC #$01
    CMP #$0a
    STA scoreDigit0
    BNE @continue
    LDA #$00
    STA scoreDigit0

    CLC
    LDA scoreDigit1
    ADC #$01
    STA scoreDigit1


    

    @continue:
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY #$00
    LDX #$00

    @loop:
   

    LDA #$20
    INY

    STA (nametable_buffer_lo), Y

    INY

    ; might have to do math here
    CLC
    TXA
    ADC #$8D
    STA (nametable_buffer_lo), Y

    LDA scoreDigit1, X 
    STA scoreDigitBuffer

    TXA
    PHA
    INY

     ; X controls the digit
    LDX scoreDigitBuffer
    LDA NUM, X
    STA (nametable_buffer_lo), Y

    PLA
    TAX
    INX
    CPX #$02
    BEQ @dump

    JMP @loop

    @dump:
    RTS


    ; move this
writeGameOver:
    ; abstract this
    ; do we need to find the last item in the buffer?
    ; or track that in another byte of RAM?
    LDA #<vram_buffer
    STA nametable_buffer_lo
    LDA #>vram_buffer
    STA nametable_buffer_hi

    ; writes game over with letters
    ; i need the array of tiles
    ; i need the starting address (but that's low and high bytes)
    LDY #$01
    LDX #$00

    @loop:
    LDA #$20
    STA (nametable_buffer_lo), Y

    INY

    ; might have to do math here
    CLC
    TXA
    ADC #$EC
    STA (nametable_buffer_lo), Y

    INY

    LDA textGameOver, X
    STA (nametable_buffer_lo), Y

    INX
    INY

    CPX #$09
    BNE @loop

    @dump:
    RTS