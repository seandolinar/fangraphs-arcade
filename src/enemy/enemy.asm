
battedBall:

    ; this does every other frame
    ; need to put in other values into the palette
    ; at least the one color...
    ; or we load in different colors into one palette and switch between that somewhere else
    LDA frameTimer
    STA consoleLog

    AND #$01

    ; palette
    ; it is either 0 or 1
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y


    LDA enemy1DirectionCurrent, X
    CMP #$01 ; UP
    BEQ @moveBallDown
    CMP #$02 ; DOWN
    BEQ @moveBallUp
    CMP #$03 ; LEFT
    BEQ @moveBallRight

    JMP @moveBallLeft ; RIGHT

    @moveBallLeft:
    LDA enemy_oam + 3, Y    

    SEC
    SBC #$0c
    
    STA enemy_oam + 3, Y
    STA enemy_oam + 11, Y

    SBC #$04
    BMI @stop

    CLC
    LDA enemy_oam + 7, Y

    SEC
    SBC #$0c
    STA enemy_oam + 7, Y
    STA enemy_oam + 15, Y

    JMP @break

    @moveBallRight:
    LDA enemy_oam + 3, Y    

    CLC
    ADC #$0c
    
    STA enemy_oam + 3, Y
    STA enemy_oam + 11, Y

    LDA enemy_oam + 7, Y

    CLC
    ADC #$0c
    STA enemy_oam + 7, Y
    STA enemy_oam + 15, Y

    BCS @stop
   
    JMP @break

    @moveBallDown:
    LDA enemy_oam, Y

    CLC
    ADC #$0c
    STA enemy_oam, Y
    STA enemy_oam + 4, Y

    LDA enemy_oam + 8, Y

    CLC
    ADC #$0c
    STA enemy_oam + 8, Y
    STA enemy_oam + 12, Y

    BCS @stop ; this might not work
    ADC #$04
    BCS @stop

    JMP @break

    @moveBallUp:
    LDA enemy_oam, Y

    SEC
    SBC #$0c
    STA enemy_oam, Y
    STA enemy_oam + 4, Y

    SBC #$04
    BMI @stop
   
    LDA enemy_oam + 8, Y

    SEC
    SBC #$0c
    STA enemy_oam + 8, Y
    STA enemy_oam + 12, Y
   

    @break:
    RTS

    @stop:

    ; this is the hard reset at the end of hitting the screen
    LDA #$80
    STA enemyX, X
    LDA #$40
    STA enemyY, X

    LDA #$03

    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    LDA #$00
    STA enemyState, X

    ; does this make it better?
    ; no
    ; CLC
    ; TYA
    ; ADC #$10
    ; TAY

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
    STX enemyCycleX
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
    CMP #$00
    BEQ @enemyMovement ; branch to normal movement
    CMP #$ff
    BEQ @halt

    ; call something else here then JMP forEachEnemyMovement
    ; i might need a lot of RAM
    LDX enemyCycleX
    JSR battedBall

    CLC
    TYA
    ADC #$10
    TAY

    @halt:
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

    ; this was CPY, why would I do that?
    CPX #$01
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




