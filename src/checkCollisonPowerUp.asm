; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionPowerUp:
    LDX powerUpAvailable

    DEX ; or this could be the source of the bug

    LDA powerUpX, X
    CMP playerLocationX
    BNE @dump 
    LDA powerUpY, X
    CMP playerLocationY
    BNE @dump 

    ; dumps out
    JSR enablePowerUp
    JSR removePowerUp


    JSR soundCollision ; Bad collision ; change this!
    RTS

@dump:
    RTS

enablePowerUp:
    LDA #$01
    STA gameStateIsPowered

    ; LDA #$0F
    ; STA bufferBackgroundColor ; might have to make this more generic

    JSR changeEnemyColor ; make this enemyState?
    JSR setTimerPowerUp
    INC powerUpAvailable

    RTS

disablePowerUp:
    LDA #$00
    STA gameStateIsPowered
    STA powerUpTimer

    ; LDA #$0F
    ; STA bufferBackgroundColor

    JSR changeEnemyColor ; make this enemyState?

    RTS
  

; turns off sprite and takes off grid
; this might not be pretty but let's try this
removePowerUp:
    STX tempX
    STY tempY

    ; find how far we have to skip
    LDY #$00
    @loop:

    TYA
    CLC
    ADC #$10                ; need to jump 16 bytes for next set of power ups
    TAY

    DEX                     ; I think we might be going out of bounds here or something
                            ; causing some issues
    CPX #$00
    BNE @loop

    ; have to loop this?
    LDX tempX
    LDA #$00
    STA powerUpX, X
    STA powerUpY, X

    LDA #$02
    STA power_up_oam + 1, Y ; + 1 is the tile ; #$02 is the empty tile
    STA power_up_oam + 5, Y
    STA power_up_oam + 9, Y
    STA power_up_oam + 13, Y

    LDX tempX
    LDY tempY
    RTS

; start the timer
setTimerPowerUp:
    LDA #$40 ; 32 cycles of something
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
