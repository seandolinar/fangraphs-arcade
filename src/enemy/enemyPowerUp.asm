changeEnemyColor:

    TXA
    PHA
    TYA
    PHA

    LDX #$04
    LDY #$00

    LDA gameStateIsPowered
    BNE changeEnemyColorPowerUp ; BNE branches if we LDA a #$00

    LDA #%0000001 ; yellow

changeEnemyColorLoop:
    DEX 
    STA enemy_oam + 2, Y

    INY
    INY
    INY
    INY

    CPX #$00
    BNE changeEnemyColorLoop

    PLA
    TAY
    PLA
    TAX

    RTS
   
changeEnemyColorPowerUp:
    LDA #%0000011 ; POWER UP STATE ; RED
    JMP changeEnemyColorLoop

    