updateScore:

    


    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY #$01
    LDX #$02 ; X controls the digit

    @loop:
    LDA #$20
    STA (nametable_buffer_lo), Y

    INY

    ; might have to do math here
    CLC
    ; TXA
    LDA #$8D
    STA (nametable_buffer_lo), Y

    INY

    LDA NUM, X
    STA (nametable_buffer_lo), Y

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