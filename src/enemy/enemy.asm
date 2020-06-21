
battedBall:
;enemy1DirectionCurrent

    ; TYA
    ; PHA

    ; ; LDA enemyX, X
    ; ; LDA #$00

    ; TXA
    ; TAY

    ; LDA #$00
    ; CPY #$04
    ; BEQ @dump
    ; @loopGetOAMY:
    ; ADC #$10
    ; DEY
    ; BNE @loopGetOAMY

    ; @dump:
    ; TAY
    ; LDY #$00

    LDA enemy_oam + 3, Y

    SEC
    SBC #$08
    STA enemy_oam + 3, Y
    STA enemy_oam + 11, Y


    LDA enemy_oam + 7, Y

    SEC
    SBC #$08
    STA enemy_oam + 7, Y
    STA enemy_oam + 15, Y

    ; CLC
    ; ADC #$08
    ; STA enemy_oam + 7
    ; STA enemy_oam + 15

    ; LDA enemyY, X

    LDA enemy_oam

    SEC
    SBC #$04
    STA enemy_oam
    STA enemy_oam + 4

    
    LDA enemy_oam + 8

    SEC
    SBC #$04
    STA enemy_oam + 8
    STA enemy_oam + 12

    ; PLA
    ; TAY

    CLC
    TYA
    ADC #$10
    TAY

    RTS


; Does this work? YES
; moved this up here because of 128 line branching limit
mainAI:

    JSR runEnemyAI           ; should be the same sub for all enemies

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
    LDY #$00
forEachEnemyMovement:

    ; this bails out if we ever hit zero
    ; might be a more elegant way to do this, but let's wait and see
    CPX #$00
    BNE @continue ; loops for other enemies
    RTS

    @continue:
    DEX

    ; this sorta works...we probably loop back around and that's an issue.
    ; need to kill the loop after the last X
    LDA enemyState, X ; we could use the state to store information
    CMP #$00
    BEQ @enemyMovement
    ; call something else here then JMP forEachEnemyMovement
    ; i might need a lot of RAM

    JSR battedBall
    JMP forEachEnemyMovement

    

    @enemyMovement:
    LDA enemyX, X
    STA enemyXBuffer            ; buffer is always temp within subroutines
    STA enemyXWork              ; work will not change, essentially a paramter of pickDirection

    LDA enemyY, X
    STA enemyYBuffer
    STA enemyYWork

    LDA enemy1DirectionCurrent, X
    STA enemyBufferDirectionCurrent

    LDA playerGridX
    STA playerGridXAI

    LDA playerGridY
    STA playerGridYAI

    LDA enemyMode
    CMP #$F0
    BCC modeAttack

    JMP modeAlt

    modeAttack:
    CPX #$03
    BEQ aiUmp4

    CPX #$02
    BEQ aiUmp3

    CPY #$01
    BEQ aiUmp2
   
    aiUmp1:
        ; do nothing
        JMP mainAI

    aiUmp2:
        LDA playerGridY
        ADC #$10
        STA playerGridYAI
        JMP mainAI

    aiUmp3:
        LDA playerGridX
        ADC #$08
        STA playerGridXAI

        LDA playerGridY
        ADC #$10
        STA playerGridYAI

        JMP mainAI

    aiUmp4:
        ; make the fourth ump target 2 tiles to the right
        LDA playerGridX
        ADC #$10
        STA playerGridXAI
        JMP mainAI

    modeAlt:
    CPX #$03
    BEQ aiUmp4Alt

    CPX #$02
    BEQ aiUmp3Alt

    CPY #$01
    BEQ aiUmp2Alt
   
    ; refactor this because it could loop
    aiUmp1Alt:
        LDA powerUpX       
        STA playerGridXAI

        LDA powerUpY       
        STA playerGridYAI
        JMP mainAI

    aiUmp2Alt:
        LDA powerUpX + 1      
        STA playerGridXAI

        LDA powerUpY + 1  
        STA playerGridYAI

        JMP mainAI

    aiUmp3Alt:
        LDA powerUpX + 2       
        STA playerGridXAI

        LDA powerUpY + 2     
        STA playerGridYAI

        JMP mainAI

    aiUmp4Alt:
        LDA powerUpX + 3  
        STA playerGridXAI

        LDA powerUpY + 3
        STA playerGridYAI
        JMP mainAI




