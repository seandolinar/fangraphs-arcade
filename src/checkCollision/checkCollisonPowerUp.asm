.segment "CODE"
checkCollisionPowerUp:
    LDX powerUpAvailable

    DEX

    LDA powerUpX, X
    CMP playerLocationX
    BNE @dump 
    LDA powerUpY, X
    CMP playerLocationY
    BNE @dump 

    ; dumps out
    JSR enablePowerUp
    JSR removePowerUp
    INC powerUpAvailable

    LDA dotsLeft
    BNE @normalPowerUp
    LDA powerUpAvailable
    CMP #$05
    BNE @normalPowerUp

    LDA frameTimer
    ADC #$30
    STA frameDelay
    JSR soundHomePlateWin

    @win:
    CLC
    LDA frameTimer
    CMP frameDelay
    BNE @win

    LDA #$ff
    STA powerUpAvailable

    JMP @break

    @normalPowerUp:
    JSR soundPowerUp

    @break:
    RTS

@dump:
    RTS

enablePowerUp:
    LDA #$01
    STA gameStateIsPowered


    JSR changeEnemyColor 
    JSR setTimerPowerUp
    
    RTS

warnPowerUp:
    LDA powerUpTimer
    AND #%00000001
    JSR changeEnemyColorLoop
    DEC powerUpTimer
    RTS


disablePowerUp:
    LDA #$00
    STA gameStateIsPowered 
    STA powerUpTimer

    JSR changeEnemyColor 

    RTS
  

; turns off sprite and takes off grid
; this might not be pretty
removePowerUp:
    PHA
    TXA
    PHA
    TYA
    PHA

    JSR startVramBuffer
    
    INY

    CLC
    LDA playerPointerHi
    ADC #$20
    STA (vram_lo), Y

    INY

    CLC
    LDA playerPointerLo
    STA (vram_lo), Y

    INY

    LDA #$34
    STA (vram_lo), Y

    STY vram_buffer_offset

    PLA
    TAY
    PLA
    TAX
    PLA

    RTS

; start the timer
setTimerPowerUp:
    TXA
    PHA

    ; default time
    LDA #$60 ; ~12 sec

    LDX inning
    CPX #$21
    BCS @noPowerUp
    CPX #$1a
    BCS @fastestPowerUp
    CPX #$0a
    BCS @fasterPowerUp
    
    JMP @storeTimer

    @noPowerUp:
    LDA #$01
    JMP @storeTimer

    @fastestPowerUp:
    LDA #$10
    JMP @storeTimer

    @fasterPowerUp:
    LDA #$30

    @storeTimer:
    STA powerUpTimer

    PLA
    TAX
    RTS

; decrement?
incTimerPowerUp:
    ; should just bail out if nothing is going on
    LDA powerUpTimer 
    CMP #$00
    BEQ dumpIncTimerPowerUp
    CMP #$01
    BEQ @reset
    CMP #$11
    BCC warnPowerUp

    @reset:
    LDA masterTimer
    CMP #$08                    ; sloppy, but the counter is only counting down to 2
    BNE dumpIncTimerPowerUp; 
    
    ; this fires if we DEC to get to 0
    ; kind of confusing
    DEC powerUpTimer
    LDA powerUpTimer
    CMP #$00
    BNE dumpIncTimerPowerUp

    JSR disablePowerUp
    
    dumpIncTimerPowerUp:
    RTS
