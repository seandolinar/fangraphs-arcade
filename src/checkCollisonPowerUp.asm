; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
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


    JSR changeEnemyColor ; make this enemyState?
    JSR setTimerPowerUp
    
    INC powerUpAvailable

    RTS

warnPowerUp:
    LDA powerUpTimer
    AND #%00000001
    JSR changeEnemyColorLoop
    DEC powerUpTimer
    RTS


disablePowerUp:
    LDA #$00
    STA gameStateIsPowered ; debug == COMMENT OUT
    STA powerUpTimer

    JSR changeEnemyColor ; make this enemyState?

    RTS
  

; turns off sprite and takes off grid
; this might not be pretty but let's try this
; have to change this
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
    LDA #$60 ;#$40 ; 32 cycles of something
    STA powerUpTimer
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
    RTS
    dumpIncTimerPowerUp:
    RTS
