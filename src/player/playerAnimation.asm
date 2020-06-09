; This controls when and how we load player sprite animations
; loop this
; setAnimationPlayerMain:
;     LDA playerDirectionCurrent
;     BEQ @dump

;     ; LDA animationTimer
;     ; CMP #$01
;     ; BEQ @forward

;     ; AND #$01 ; this is controlling the animation by being even / odd
;     ; BEQ @forward

;     CLC
;     LDA playerGridY
;     ADC playerGridX
;     AND #$01
;     BEQ @forward

;     ; NORMAL LOGO
;     ; FACING RIGHT
;     LDA #$12
;     STA player_oam + 1

;     LDA #$13
;     STA player_oam + 9
;     RTS

;     LDA #$22
;     STA player_oam + 5

;     LDA #$23
;     STA player_oam + 13
;     RTS

;     ; SWING ANIMATION
;     ; FACING RIGHT
;     @forward:
;     LDA #$32
;     STA player_oam + 1

;     LDA #$33
;     STA player_oam + 9

;     LDA #$42
;     STA player_oam + 5

;     LDA #$43
;     STA player_oam + 13
    
;     @dump:
;     RTS

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

    JMP @incrementTimer

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

    LDA #%01000000
    STA player_oam + 2
    STA player_oam + 6
    STA player_oam + 10
    STA player_oam + 14

    JMP @incrementTimer


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

    JMP @incrementTimer


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

    JMP @incrementTimer

    @incrementTimer:
    ; INC animationTimer
    ; LDA animationTimer
    ; CMP #$03
    ; BEQ @resetTimer
    RTS

    @resetTimer:
    LDA #$00
    STA animationTimer
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