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

changeEnemyColor:

    TXA
    PHA
    TYA
    PHA

    LDX #$02
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

    

; need to check the all four directions
; run through the three directions and collision check
; have to omit the backwards direction
; check direction, dump if we are the opposite
; have available directions
; pick one
; if we only have one, continue

; if we are going up, then we need to check up, left, right
; then pick one of those 
; figure out if I can use the stack here for a loop
