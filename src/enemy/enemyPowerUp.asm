changeEnemyColor:

    TXA
    PHA
    TYA
    PHA

    LDX #$04
    LDY #$00

    LDA gameStateIsPowered
    BNE changeEnemyColorPowerUp ; BNE branches if we LDA a #$00

    ; pallete attribute for the power up
    LDA #%0000000 ; yellow ; return them to normal

changeEnemyColorLoop:
    DEX 
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    ; adds 16 to Y
    PHA
    CLC
    TYA
    ADC #$10
    TAY
    PLA

    CPX #$00
    BNE changeEnemyColorLoop

    LDA gameStateIsPowered
    BNE @palleteChangeOff ; BNE branches if we LDA a #$00

    JSR startVramBuffer
    INY

    LDA #$3F
    STA (vram_lo), Y

    INY

    LDA #$1d
    STA (vram_lo), Y

    INY
    LDA #$0F
    STA (vram_lo), Y


    INY

    LDA #$3F
    STA (vram_lo), Y

    INY

    LDA #$1f
    STA (vram_lo), Y

    INY
    LDA #$25
    STA (vram_lo), Y

    STY vram_buffer_offset

    JMP @exit


    @palleteChangeOff:
    ; changes pallette
    JSR startVramBuffer
    INY

    LDA #$3F
    STA (vram_lo), Y

    INY

    LDA #$1d
    STA (vram_lo), Y

    INY
    LDA #$16
    STA (vram_lo), Y

    ;;;;
    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$1f
    STA (vram_lo), Y

    INY
    LDA #$20
    STA (vram_lo), Y

    STY vram_buffer_offset


    @exit:

    PLA
    TAY
    PLA
    TAX

    RTS
   
changeEnemyColorPowerUp:
    LDA #%00000011 ; POWER UP STATE ; RED

   





    JMP changeEnemyColorLoop

    