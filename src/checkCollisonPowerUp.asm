; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionPowerUp:
    LDX #$01
checkCollisionPowerUpLoop:

    DEX
    LDA powerUpX, X
    CMP playerLocationX
    BNE dumpCheckCollisionPowerUp
    LDA powerUpY, X
    CMP playerLocationY
    BNE dumpCheckCollisionPowerUp

    JSR enablePowerUp
    JSR removePowerUp

    JSR soundCollision ; Bad collision ; change this!
    RTS

dumpCheckCollisionPowerUp:
    CPX #$00
    BNE checkCollisionPowerUpLoop
    RTS

enablePowerUp:
    LDA #$01
    STA gameStateIsPowered

    JSR changeEnemyColor ; make this enemyState?
    JSR setTimerPowerUp

    RTS

disablePowerUp:
    LDA #$00
    STA gameStateIsPowered
    STA powerUpTimer

    JSR changeEnemyColor ; make this enemyState?

    RTS
  

; spin out
removePowerUp:
    LDA #$00
    STA powerUpX, X
    STA powerUpY, X
    LDA #$02
    STA power_up_oam + 1, X ; + 1 is the tile ; #$02 is the empty tile
    RTS

; start the timer
setTimerPowerUp:
    LDA #$20 ; 32 cycles of something
    STA powerUpTimer
    RTS

incTimerPowerUp:
    LDA powerUpTimer ; should just bail out if nothing
    CMP #$00
    BEQ dumpIncTimerPowerUp

    LDA masterTimer
    CMP #$01 ; not sure why 1, we might not be counting down all the way before reseting
    BNE dumpIncTimerPowerUp; 
    
    DEC powerUpTimer
    LDA powerUpTimer
    CMP #$00
    BNE dumpIncTimerPowerUp

    JSR disablePowerUp
    RTS
dumpIncTimerPowerUp:
    RTS
