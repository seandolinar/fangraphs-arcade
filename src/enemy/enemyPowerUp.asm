changeEnemyColor:
    ; this is called just once, need to write the loop here

    TXA
    PHA
    TYA
    PHA

    LDX #$04
    LDY #$00

    LDA gameStateIsPowered
    BNE changeEnemyColorPowerUp ; BNE branches if we LDA a #$00

    LDA #%0000010 ; yellow ; return them to normal

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

    PLA
    TAY
    PLA
    TAX

    RTS
   
changeEnemyColorPowerUp:
    LDA #%00000011 ; POWER UP STATE ; RED
    JMP changeEnemyColorLoop

    