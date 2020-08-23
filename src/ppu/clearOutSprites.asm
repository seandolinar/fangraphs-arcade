
clearOutSprites:
    @LoadEnemy:
    LDX #$00
    @LoadEnemyLoop:
    LDA enemy_array, X      
    STA enemy_oam , X        

    LDA enemy_array + 1, X        
    STA enemy_oam + 1 , X         

    LDA enemy_array + 2, X       
    STA enemy_oam + 2, X         

    LDA enemy_array+3, X
    STA enemy_oam+3, X             

    INX
    INX
    INX
    INX
    
    CPX #$40
    BNE @LoadEnemyLoop  
    
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