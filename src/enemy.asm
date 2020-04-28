nextEnemyMovement:
    LDX #$02            ; how many enemies we have
    LDY #$00
forEachEnemyMovement:
    DEX

enemyMovement:
    LDA enemyX, X
    STA enemyXBuffer            ; buffer is always temp within subroutines
    STA enemyXWork              ; work will not change, essentially a paramter of pickDirection

    LDA enemyY, X
    STA enemyYBuffer
    STA enemyYWork

    LDA enemy1DirectionCurrent, X
    STA enemyBufferDirectionCurrent

    JSR pickDirection           ; should be the same sub for all enemies

    LDA enemyBufferDirectionCurrent
    STA enemy1DirectionCurrent, X
       
    @moveHorizontal:
        CLC
        LDA enemyXBuffer
        STA enemyX, X           ; enemy X RAM
        STA enemy_oam + 3, Y    ; sprite RAM x

    @moveVertical:
        CLC
        LDA enemyYBuffer 
        STA enemyY, X           ; enemy Y RAM
        STA enemy_oam, Y        ; sprite RAM y

dumpEnemyController:

        INY
        INY
        INY
        INY
        CPX #$00
        BNE forEachEnemyMovement ; loops for other enemies

        RTS

