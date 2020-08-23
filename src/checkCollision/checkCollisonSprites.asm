; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionSprites:
    LDX #$04
    STX enemyCycleX

    ; TODO:
    ; DEBUG
    ; RTS


    @loop:
    LDX enemyCycleX ; didn't fix anything
    DEX
    STX enemyCycleX

    LDA enemyX, X
    CMP playerLocationX
    BNE @dump
    LDA enemyY, X
    CMP playerLocationY
    BNE @dump

    LDA gameStateIsPowered
    CMP #$01
    BEQ @collisionGood

    ; TODO:
    ; RTS ; DEBUG

    ; Bad collision path
    JSR soundCollisionBad
    JSR animatePlayerOut
    JSR playerReset
    
    LDA #$02
    STA enemyState
    STA enemyState + 1
    STA enemyState + 2
    STA enemyState + 3


    ;;;;
    JSR clearOutSprites
    ;;;;

    JSR enemyReset

    LDA #$01
    STA gamePlayerReset

    ;;;
    ; PPU update update outs graphic
    ;;; 
    JSR startVramBuffer
    INY

    CLC
    LDA #$20
    STA (vram_lo), Y

    INY

    CLC
    LDA gameOuts
    ADC #$F2
    STA (vram_lo), Y


    INY
    LDA #$46
    STA (vram_lo), Y

    STY vram_buffer_offset

    ; reset timer
    LDA frameTimer
    ADC #$90
    STA frameDelay


    INC gameOuts
    LDA gameOuts
    CMP #$03
    BNE @dumpBad

    @dumpBad:
    RTS

    @collisionGood:
    LDA #$0a
    STA scoreValue
    JSR updateScore
    JSR soundCollisionGood ; this is causing the issue
    JSR resetOneEnemyPosition

    @dump:
    CPX #$00
    BNE @loop
    RTS
  
;; this loop won't work because it will only stop if it's the last one.
;; so i might need to invert this whole thing



; this uses X from checkCollisionSprites
resetOneEnemyPosition:    
    ; turn off the enemy active state
    LDX enemyCycleX
    LDA #$01
    STA enemyState, X
    
    LDA #$00
    STA enemyX, X
    STA enemyY, X

    RTS

