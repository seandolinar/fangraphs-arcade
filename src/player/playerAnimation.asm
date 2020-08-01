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

animationReverse:
    .byte $55, $54, $65, $64
    .byte $75, $74, $85, $84
    .byte $95, $94, $a5, $a4
    .byte $57, $56, $67, $66
    .byte $73, $72, $83, $82

animatePlayerOut:
    ; this is getting run


    LDA #$00
    STA frameTimer


    LDA playerDirectionCurrent
    CMP #$03
    BEQ @setReverse
    
    ; don't blow away x?
    LDX #$00
    @loopAnimation:
    LDA #$00
    STA frameTimer
    @loopAnimationDelay:
    LDA frameTimer
    CMP #$0b
    BNE @loopAnimationDelay

    TXA
    PHA

    ASL
    ASL

    TAX

    LDA animationNormal, X
    STA player_oam + 1

    LDA animationNormal + 1, X
    STA player_oam + 9

    LDA animationNormal + 2, X
    STA player_oam + 5

    LDA animationNormal + 3, X
    STA player_oam + 13

    PLA
    TAX

    INX

    CPX #$05
    BNE @loopAnimation

    JMP @loopDelayStart


    @setReverse:

    LDX #$00
    @loopAnimationReverse:
    LDA #$00
    STA frameTimer
    @loopAnimationDelayReverse:
    LDA frameTimer
    CMP #$0b
    BNE @loopAnimationDelayReverse

    TXA
    PHA

    ASL
    ASL

    TAX


    LDA animationReverse, X
    STA player_oam + 1

    LDA animationReverse + 1, X
    STA player_oam + 9

    LDA animationReverse + 2, X
    STA player_oam + 5

    LDA animationReverse + 3, X
    STA player_oam + 13

    PLA
    TAX

    INX

    CPX #$05
    BNE @loopAnimationReverse
  
    @loopDelayStart:   
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
