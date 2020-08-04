battedBall:
    ; this subroutine controls the sprite movement 
    ; after the player makes good contact with an enemy
    ; the enemy then flies off the screen 
    ; opposite of the direction they were traveling



    ; this does every other frame
    ; need to put in other values into the palette
    ; at least the one color...
    ; or we load in different colors into one palette and switch between that somewhere else
    LDA frameTimer
    AND #$01

    ; palette
    ; it is either 0 or 1
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    LDA enemy1DirectionCurrent, X
    CMP #DIRECTION_UP ; UP
    BEQ @moveBallDown
    CMP #DIRECTION_DOWN ; DOWN
    BEQ @moveBallUp
    CMP #DIRECTION_LEFT ; LEFT
    BEQ @moveBallRight

    JMP @moveBallLeft ; RIGHT

    @moveBallLeft:
    ; leading left edge
    LDA enemy_oam + 3, Y    
    SBC #$10
    BMI @stopBridge
    STA enemy_oam + 3, Y
    STA enemy_oam + 11, Y

    SEC
    LDA enemy_oam + 7, Y
    SBC #$10
    STA enemy_oam + 7, Y
    STA enemy_oam + 15, Y

    JMP @break

    @stopBridge:
    JMP @stop

    @moveBallRight:
    CLC
    LDA enemy_oam + 3, Y    
    ADC #$10
    STA enemy_oam + 3, Y
    STA enemy_oam + 11, Y

    ; leading right edge
    CLC
    LDA enemy_oam + 7, Y
    ADC #$10
    BCS @stop
    STA enemy_oam + 7, Y
    STA enemy_oam + 15, Y
   
    JMP @break

    @moveBallDown:
    LDA enemy_oam, Y

    CLC
    ADC #$0c
    BCS @stop
    ADC #$04
    BCS @stop

    STA enemy_oam, Y
    STA enemy_oam + 4, Y

    LDA enemy_oam + 8, Y

    CLC
    ADC #$0c
    BCS @stop
    ADC #$04
    BCS @stop
    STA enemy_oam + 8, Y
    STA enemy_oam + 12, Y

    BCS @stop
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
    ; this location is within the scoreboard
    LDA #$80
    STA enemyX, X
    LDA #$38
    STA enemyY, X

    ; this should reset the palette
    LDA #$03

    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    LDA #$f0
    STA enemy_oam, Y
    STA enemy_oam + 4, Y
    STA enemy_oam + 8, Y
    STA enemy_oam + 12, Y


    LDA #$02
    STA enemyState, X

    RTS
