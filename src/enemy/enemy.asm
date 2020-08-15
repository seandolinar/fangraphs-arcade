; Does this work? YES
; moved this up here because of 128 line branching limit
mainAI:

    JSR runEnemyAI           ; should be the same sub for all enemies

noAI:
    ; this is the engine, we can use this for our new state
    LDA enemyBufferDirectionCurrent
    STA enemy1DirectionCurrent, X
       
    @moveHorizontal:
        CLC
        LDA enemyXBuffer
        STA enemyX, X           ; enemy X RAM

        SEC
        SBC #$04
        STA enemy_oam + 3, Y    ; sprite RAM x
        STA enemy_oam + 11, Y    ; sprite RAM x

        CLC
        ADC #$08
        STA enemy_oam + 7, Y    ; sprite RAM x
        STA enemy_oam + 15, Y    ; sprite RAM x

    @moveVertical:
        CLC
        LDA enemyYBuffer 
        STA enemyY, X           ; enemy Y RAM

        SEC
        SBC #$04
        STA enemy_oam, Y        ; sprite RAM y
        STA enemy_oam + 4, Y    ; sprite RAM y

        ADC #$06
        STA enemy_oam + 8, Y    ; sprite RAM y
        STA enemy_oam + 12, Y    ; sprite RAM y


dumpEnemyController:

        CLC
        TYA
        ADC #$10
        TAY

        CPX #$00
        BNE forEachEnemyMovement ; loops for other enemies

        RTS

; START
nextEnemyMovement:
    LDX #$04            ; how many enemies we have
    ; LDX #$01
    STX enemyCycleX

    LDY #$00
forEachEnemyMovement:

    ; this bails out if we ever hit zero
    ; might be a more elegant way to do this, but let's wait and see
    CPX #$00
    BNE @continue ; loops for other enemies
    RTS

    @continue:
    LDX enemyCycleX
    DEX
    STX enemyCycleX

    ; this sorta works...we probably loop back around and that's an issue.
    ; need to kill the loop after the last X
    LDA enemyState, X ; we could use the state to store information
    CMP #ENEMY_STATE_GAME_PLAY
    BEQ enemyAIMovementSetup ; branch to start enemy AI movement
    CMP #ENEMY_STATE_DOOR
    BEQ @hold
    CMP #ENEMY_STATE_HALT
    BEQ @halt

    ; Branch for ENEMY_STATE_BATTED
    JSR battedBall

    CLC
    TYA
    ADC #$10
    TAY

    JMP @halt

    @hold:
    ; so this is how we can execute "entering enemies"
    ; might need to write something that open and shuts the door that cycles show the 4 bytes of ram for enemy states
    ; make a loop that short circuits if we have more than one state = 2 
    LDA isEnemyLeaving
    CMP #$ff
    BEQ @start
    CPX isEnemyLeaving
    BEQ @start

    ; putting this in??? should this change?
    CLC
    TYA
    ADC #$10
    TAY

    JMP @halt

    @start:
    LDA enemyX, X
    STA enemyXBuffer
    LDA enemyY, X
    ADC #$02
    STA enemyY, X
    STA enemyYBuffer

    STX isEnemyLeaving

    LDA gameStateIsPowered
    CMP #$00
    BEQ @continuePalette
    LDA #$03
    JMP @storePalette

    @continuePalette:
    TXA
    @storePalette:
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    LDA enemyY, X
    CMP #$48
    BCS @setNormal

    
    @skip:
    JMP noAI

    @setNormal:
    LDA #$48
    STA enemyY, X
    STA enemyYBuffer
    LDA #$00
    STA enemyState, X
    LDA #$ff
    STA isEnemyLeaving

    ; need this to prevent the "skipping"
    JMP noAI

    @halt:
    JMP forEachEnemyMovement

    

