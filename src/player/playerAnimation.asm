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

    ; CLC
    ; LDA playerGridY
    ; ADC playerGridX
    ; AND #$01
    ; BEQ @stance

    LDA animationTimer
    CMP #$01
    BEQ @stance
    CMP #$02
    BEQ @animationPt3

    ; ANIMATION
    ; FACING LEFT
    LDA #$33
    STA player_oam + 1
    LDA #$32
    STA player_oam + 9
    LDA #$43
    STA player_oam + 5
    LDA #$42
    STA player_oam + 13

    JMP @exit

    @stance:
    ; NORMAL LOGO
    ; FACING LEFT
    LDA #$13
    STA player_oam + 1
    LDA #$12
    STA player_oam + 9
    LDA #$23
    STA player_oam + 5
    LDA #$22
    STA player_oam + 13

    JMP @exit

    @animationPt3:
    LDA #$53
    STA player_oam + 1
    LDA #$52
    STA player_oam + 9
    LDA #$63
    STA player_oam + 5
    LDA #$62
    STA player_oam + 13

    ; LDA #%01000000
    ; STA player_oam + 2
    ; STA player_oam + 6
    ; STA player_oam + 10
    ; STA player_oam + 14

    JMP @exit


    @setNormal:
    LDA #%00000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    ; CLC
    ; LDA playerGridY
    ; ADC playerGridX
    ; AND #$01
    ; BEQ @stanceNormal

    LDA animationTimer
    CMP #$01
    BEQ @stanceNormal
    CMP #$02
    BEQ @animationPt3Normal

    ; ANIMATION
    ; FACING RIGHT
    LDA #$32
    STA player_oam + 1
    LDA #$33
    STA player_oam + 9
    LDA #$42
    STA player_oam + 5
    LDA #$43
    STA player_oam + 13

    JMP @exit


    ; NORMAL LOGO
    ; FACING RIGHT
    @stanceNormal:
    LDA #$12
    STA player_oam + 1
    LDA #$13
    STA player_oam + 9
    LDA #$22
    STA player_oam + 5
    LDA #$23
    STA player_oam + 13

    JMP @exit

    @animationPt3Normal:
    LDA #$52
    STA player_oam + 1
    LDA #$53
    STA player_oam + 9
    LDA #$62
    STA player_oam + 5
    LDA #$63
    STA player_oam + 13
    JMP @exit

    @exit:
   
    RTS



incrementAnimationTimer:
    INC animationTimer
    LDA animationTimer
    CMP #$03
    BEQ @resetTimer
    RTS

    @resetTimer:
    LDA #$00
    STA animationTimer
    RTS