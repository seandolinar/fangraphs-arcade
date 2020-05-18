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

    JSR soundCollision ; Bad collision
    JSR resetPlayerReset
    JSR enemyReset


    ; LDA $2001
    ; EOR #%0001000
    ; STA $2001

    ; LDA $2000
    ; EOR #%1000000
    ; STA $2000

    ; this loops isn't bailing out
    ; probably want to put this in the NMI?
    ; @tempLoop:
    ; JSR readController
    ; LDA controllerBits
    ; AND #CONTROL_P1_RIGHT  ; zeros out non-start bits
    ; BNE @dumpBad

    ; JMP @tempLoop
    LDA #$01
    STA gamePlayerReset

    ; structure or label this or move this
    LDA #<vram_buffer
    STA nametable_buffer_lo
    LDA #>vram_buffer
    STA nametable_buffer_hi
    LDY #$01
    LDA #$20
    STA (nametable_buffer_lo), Y

    INY

    CLC
    LDA gameOuts
    ADC #$F1
    STA (nametable_buffer_lo), Y

    INY
    LDA #$01
    STA (nametable_buffer_lo), Y

    INC gameOuts
    LDA gameOuts
    CMP #$03
    BNE @dumpBad

    LDA #$16
    STA bufferBackgroundColor

    @dumpBad:
    RTS

    @collisionGood:
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
    LDA #$80
    STA enemyX, X
    LDA #$50
    STA enemyY, X
    RTS
