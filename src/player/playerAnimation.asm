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

    LDA animationTimer
    CMP #$01
    BEQ @animationPt3
    CMP #$02
    BEQ @stance
    CMP #$03
    BEQ @stance
    CMP #$04
    BEQ @stance

    ; ANIMATION -- MIDDLE
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
    ; ANIMATION -- FULL SWING
    LDA #$53
    STA player_oam + 1
    LDA #$52
    STA player_oam + 9
    LDA #$63
    STA player_oam + 5
    LDA #$62
    STA player_oam + 13

    JMP @exit

    @setNormal:
    LDA #%00000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    LDA animationTimer
    CMP #$01
    BEQ @animationPt3Normal
    CMP #$02
    BEQ @animationPt3Normal
    CMP #$03
    BEQ @stanceNormal
    CMP #$04
    BEQ @stanceNormal

    ; ANIMATION -- MID
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
    ; ANIMATION -- FULL SWING
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
    CMP #$06
    BEQ @resetTimer
    RTS

    @resetTimer:
    LDA #$00
    STA animationTimer
    RTS


animationNormal:
    .byte $54, $55, $64, $65
    .byte $74, $75, $84, $85
    .byte $94, $95, $a4, $a5
    .byte $56, $57, $66, $67
    .byte $72, $73, $82, $83

animatePlayerEnd:
    LDA #$00
    STA frameTimer

    LDA playerDirectionCurrent
    CMP #$03
    ; BEQ @setLeftward

    ; don't blow away x/y?
    LDY #$00
    LDX #$00
    @loopAnimation:
    LDA #$00
    STA frameTimer
    @loopAnimationDelay:
    LDA frameTimer
    CMP #$20
    BNE @loopAnimationDelay

    TXA
    PHA

    ASL
    ASL

    TAX

    LDA animationNormal, X
    STA player_oam + 1
    ; INX
    LDA animationNormal + 1, X
    STA player_oam + 9

    ; INX
    LDA animationNormal + 2, X
    STA player_oam + 5
    ; INX
    LDA animationNormal + 3, X
    STA player_oam + 13

    ; TYA
    ; CLC
    ; ADC $10
    ; TAY

    PLA
    TAX

    INX

    CPX #$06
    BNE @loopAnimation

    ; LDA #$00
    ; STA frameTimer
    ; @loop2:
    ; LDA frameTimer
    ; CMP #$20
    ; BNE @loop2

    ; LDA #$74
    ; STA player_oam + 1
    ; LDA #$75
    ; STA player_oam + 9
    ; LDA #$84
    ; STA player_oam + 5
    ; LDA #$85
    ; STA player_oam + 13

    ; LDA #$00
    ; STA frameTimer
    ; @loop3:
    ; LDA frameTimer
    ; CMP #$20
    ; BNE @loop3

    ; LDA #$94
    ; STA player_oam + 1
    ; LDA #$95
    ; STA player_oam + 9
    ; LDA #$a4
    ; STA player_oam + 5
    ; LDA #$a5
    ; STA player_oam + 13

    ; LDA #$00
    ; STA frameTimer
    ; @loop4:
    ; LDA frameTimer
    ; CMP #$20
    ; BNE @loop4

    ; LDA #$56
    ; STA player_oam + 1
    ; LDA #$57
    ; STA player_oam + 9
    ; LDA #$66
    ; STA player_oam + 5
    ; LDA #$67
    ; STA player_oam + 13

    ; LDA #$00
    ; STA frameTimer
    ; @loop5:
    ; LDA frameTimer
    ; CMP #$20
    ; BNE @loop5

    ; LDA #$72
    ; STA player_oam + 1
    ; LDA #$73
    ; STA player_oam + 9
    ; LDA #$82
    ; STA player_oam + 5
    ; LDA #$83
    ; STA player_oam + 13

    ; LDA #$00
    ; STA frameTimer
    ; @loop6:
    ; LDA frameTimer
    ; CMP #$20
    ; BNE @loop6



    JMP @loopDelay


    @setLeftward:

    ; LDA #$73
    ; STA player_oam + 1
    ; LDA #$72
    ; STA player_oam + 9
    ; LDA #$83
    ; STA player_oam + 5
    ; LDA #$82
    ; STA player_oam + 13

    
    LDA #$00
    STA frameTimer
    @loopDelay:
    LDA frameTimer
    CMP #$20
    BNE @loopDelay

    LDA #%00000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    LDA #$92
    STA player_oam + 1
    LDA #$93
    STA player_oam + 9
    LDA #$a2
    STA player_oam + 5
    LDA #$a3
    STA player_oam + 13

    RTS
