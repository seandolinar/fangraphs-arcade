; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionSprites:
    LDX #$04
    STX enemyCycleX

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

    ; RTS ; DEBUG

    ; ; Bad collision path
    JSR soundCollision
    JSR animatePlayerOut
    JSR playerReset
    
    ; might be able to put this into the playerReset SUB
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


clearOutSprites:
    @LoadEnemy:
    LDX #$00
    @LoadEnemyLoop:
    LDA enemy_array, X       ; load data from address (sprites +  x) ; Y    
    STA enemy_oam , X          ; store into RAM address ($0200 + x)

    LDA enemy_array + 1, X        ; load data from address (sprites +  x) ; TILE
    STA enemy_oam + 1 , X         ; store into RAM address ($0200 + x)

    LDA enemy_array + 2, X        ; load data from address (sprites +  x) ; ATTR
    STA enemy_oam + 2, X         ; store into RAM address ($0200 + x)

    LDA enemy_array+3, X
    STA enemy_oam+3, X              ; X = X + 1 ; X

    INX
    INX
    INX
    INX
    
    CPX #$40
    BNE @LoadEnemyLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
    
    RTS