; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionSprites:
    LDX #$04
    
    @loop:
    DEX
    LDA enemyX, X
    CMP playerLocationX
    BNE @dump
    LDA enemyY, X
    CMP playerLocationY
    BNE @dump

    LDA gameStateIsPowered
    CMP #$01
    BEQ @collisionGood

    ; ; Bad collision path
    JSR soundCollision
    JSR animatePlayerEnd
    JSR playerReset
    JSR enemyReset

    LDA #$01
    STA gamePlayerReset

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
    STY $7003


    INC gameOuts
    LDA gameOuts
    CMP #$03
    BNE @dumpBad

    LDA #$16
    STA bufferBackgroundColor

    @dumpBad:
    RTS

    @collisionGood:
    LDA #$0a
    STA scoreValue
    JSR updateScore
    JSR soundCollisionGood
    JSR resetOneEnemyPosition

   
    @dump:
    CPX #$00
    BNE @loop
    RTS
  
;; this loop won't work because it will only stop if it's the last one.
;; so i might need to invert this whole thing



; this uses X from checkCollisionSprites
resetOneEnemyPosition:
    LDA #$00
    STA enemyState, X
    ; LDA #$80
    LDA #$00
    STA enemyX, X
    ; LDA #$50
    STA enemyY, X


    ; so we'll need to increment by a lot here
    ; probably have to save Y
    ; this works
    LDA #$10

    SEC
    SBC #$04
    STA enemy_oam + 3
    STA enemy_oam + 11

    CLC
    ADC #$08
    STA enemy_oam + 7
    STA enemy_oam + 15

    LDA #$10

    SEC
    SBC #$04
    STA enemy_oam
    STA enemy_oam + 4

    ADC #$06
    LDA #$14
    STA enemy_oam + 8
    STA enemy_oam + 12

    RTS
