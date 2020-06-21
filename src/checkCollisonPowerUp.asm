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
    ; JSR soundCollision ; Bad collision ; change this!

    LDA #$01
	JSR FamiToneMusicPlay

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

disablePowerUp:
    LDA #$00
    STA gameStateIsPowered
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

    ; INY

    STY vram_buffer_offset

    PLA
    TAY
    PLA
    TAX
    PLA

    RTS

; start the timer
setTimerPowerUp:
    LDA #$a0 ;#$40 ; 32 cycles of something
    STA powerUpTimer
    RTS

incTimerPowerUp:
    LDA powerUpTimer ; should just bail out if nothing
    CMP #$00
    BEQ dumpIncTimerPowerUp

    LDA masterTimer
    CMP #$08                    ; sloppy, but the counter is only counting down to 2
    BNE dumpIncTimerPowerUp; 
    
    DEC powerUpTimer
    LDA powerUpTimer
    CMP #$00
    BNE dumpIncTimerPowerUp

    JSR disablePowerUp
    RTS
dumpIncTimerPowerUp:
    RTS
