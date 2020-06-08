; This controls when and how we load player sprite animations
; loop this
setAnimationPlayerMain:
    LDA playerDirectionCurrent
    BEQ @dump

    CLC
    LDA playerGridY
    ADC playerGridX
    AND #$01 ; this is controlling the animation by being even / odd
    BEQ @forward

    LDA #$12
    STA player_oam + 1

    LDA #$13
    STA player_oam + 9
    RTS

    LDA #$22
    STA player_oam + 5

    LDA #$23
    STA player_oam + 13
    RTS


    @forward:
    LDA #$32
    STA player_oam + 1

    LDA #$33
    STA player_oam + 9

    LDA #$42
    STA player_oam + 5

    LDA #$43
    STA player_oam + 13
    
    @dump:
    RTS

setAnimationPlayerDirection:
    
    LDA playerDirectionCurrent
    CMP #$03
    BEQ @setLeftward

    JMP @setNormal

    @setLeftward:
    LDA #%01000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    CLC
    LDA playerGridY
    ADC playerGridX
    AND #$01
    BEQ @stance

    ;depenedent on my setup
    LDA #$33
    STA player_oam + 1
    LDA #$32
    STA player_oam + 9
    LDA #$43
    STA player_oam + 5
    LDA #$42
    STA player_oam + 13

    RTS

    @stance:
    ;depenedent on my setup
    LDA #$13
    STA player_oam + 1
    LDA #$12
    STA player_oam + 9
    LDA #$23
    STA player_oam + 5
    LDA #$22
    STA player_oam + 13

    LDA #%01000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    RTS


    @setNormal:
    LDA #%00000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    CLC
    LDA playerGridY
    ADC playerGridX
    AND #$01
    BEQ @stanceNormal

    LDA #$32
    STA player_oam + 1

    LDA #$33
    STA player_oam + 9


    LDA #$42
    STA player_oam + 5

    LDA #$43
    STA player_oam + 13

    RTS



    @stanceNormal:
    LDA #$12
    STA player_oam + 1

    LDA #$13
    STA player_oam + 9

    LDA #$22
    STA player_oam + 5

    LDA #$23
    STA player_oam + 13



    RTS
