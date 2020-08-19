
clearOutSprites:
    @LoadEnemy:
    LDX #$00
    @LoadEnemyLoop:
    LDA enemy_array, X       ; load data from address (sprites +  x) ; Y    
    STA enemy_oam , X          ; store into RAM address ($0200 + x)

    LDA enemy_array + 1, X        ; load data from address (sprites +  x) ; TILE
    STA enemy_oam + 1 , X         ; store into RAM address ($0200 + x)

    LDA enemy_array + 2, X        ; load data from address (sprites +  x) ; ATTR
    STA enemy_oam + 2, X         ; store into RAM address ($0200 + x)

    LDA enemy_array+3, X
    STA enemy_oam+3, X              ; X = X + 1 ; X

    INX
    INX
    INX
    INX
    
    CPX #$40
    BNE @LoadEnemyLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
    
    RTS

clearOutSpritesPlayer:
    LDA #$00
    LDX #$00

    @clearPlayerLoop:
    STA player_oam, X
    STA player_oam + 1, X
    STA player_oam + 2, X
    STA player_oam + 3, X

    INX
    INX
    INX
    INX

    CPX #$10
    BNE @clearPlayerLoop

    RTS