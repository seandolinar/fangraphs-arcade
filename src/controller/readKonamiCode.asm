readKonamiCode:
  
    ; checks the code sequence
    LDA konamiCode
    CMP #$00
    BEQ @buttonUp
    CMP #$01
    BEQ @buttonNone
    CMP #$02
    BEQ @buttonUp
    CMP #$03
    BEQ @buttonNone
    CMP #$04
    BEQ @buttonDown
    CMP #$05
    BEQ @buttonNone
    CMP #$06
    BEQ @buttonDown
    CMP #$07
    BEQ @buttonNone
    CMP #$08
    BEQ @buttonLeft
    CMP #$09
    BEQ @buttonNone
    CMP #$0a
    BEQ @buttonRight
    CMP #$0b
    BEQ @buttonNone
    CMP #$0c
    BEQ @buttonLeft
    CMP #$0d
    BEQ @buttonNone
    CMP #$0e
    BEQ @buttonRight
    CMP #$0f
    BEQ @buttonNone
    CMP #$10
    BEQ @buttonB
    CMP #$11
    BEQ @buttonNone
    CMP #$12
    BEQ @buttonA
    JMP @skipButton

    @buttonNone:
    ; JSR readController ; not sure if I need this
    LDA controllerBits
    BNE @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonUp:
    LDA controllerBits
    AND #CONTROL_P1_UP
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonDown:
    LDA controllerBits
    AND #CONTROL_P1_DOWN
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonLeft:
    LDA controllerBits
    AND #CONTROL_P1_LEFT
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonRight:
    LDA controllerBits
    AND #CONTROL_P1_RIGHT
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonA:
    LDA controllerBits
    AND #CONTROL_P1_A
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode

    @buttonB:
    LDA controllerBits
    AND #CONTROL_P1_B
    BEQ @skipButton

    INC konamiCode
    JMP @continueCode
   
    ; starts button delay
    ; sets timeout for code
    @continueCode:
    CLC
    LDA frameTimer
    ADC #$30
    STA buttonDelay

    ; see if we sucessfully entered code
    LDA konamiCode
    CMP #$13
    BEQ @enableCheat

    ; no cheat
    JMP @break
    
    ; successful cheat
    @enableCheat:
    JSR FamiToneMusicStop
    JSR soundPowerUp
    JSR enablePowerUp
    LDA #$01
    STA hasCheated

    ; writes cheat indicator
    JSR updateKonami

    JMP @exit

    ; button was pressed 
    ; was wrong button
    @skipButton:
    LDA controllerBits
    CMP #$00
    BEQ @exit

    LDA buttonDebounce
    CMP frameTimer
    BNE @exit

    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    BNE @exit

    ; error entering code
    ; reset    
    @resetKonamiCode:
    LDA #$00
    STA konamiCode

    JMP @exit

    ; debounce so that we don't read the controller every frame
    @break:
    LDA frameTimer
    ADC #$10
    STA buttonDebounce
    
    @exit:
    RTS