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

        ; INY
        ; INY
        ; INY
        ; INY
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
    ; LDX #$02            ; how many enemies we have ; temp

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
        LDA powerUpX2       
        STA playerGridXAI

        LDA powerUpY2       
        STA playerGridYAI

        JMP mainAI

    aiUmp3Alt:
        LDA powerUpX3       
        STA playerGridXAI

        LDA powerUpY3       
        STA playerGridYAI

        JMP mainAI

    aiUmp4Alt:
        LDA powerUpX3       
        STA playerGridXAI

        LDA powerUpY3       
        STA playerGridYAI
        JMP mainAI




