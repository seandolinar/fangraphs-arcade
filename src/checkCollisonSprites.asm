; this is actually doing something
; but it's not right
; let's get rid of the X loop
; let's make this separate so it just checks if they are in the same place.
; if this is kept on a grid, we can just compare the straight up X/Y RAM coords without much math
.segment "CODE"
checkCollisionSprites:
    LDX #$00
checkCollisionLoop:

    LDA enemyX
    CMP playerLocationX
    BNE dumpCheckSpriteCollison
    LDA enemyY
    CMP playerLocationY
    BNE dumpCheckSpriteCollison

    JSR soundBallCollisionWall


    ; SHORT CIRCUIT ;
    JMP dumpCheckSpriteCollison

    ; spriteW = #$04
    LDY #$04

    ; ENEMY CHECK
    ; checking if player is on right edge
    LDA enemyX
    CLC
    ; ADC #$04 ; sprite W
    CMP playerLocationX
    BMI dumpCheckSpriteCollison 

    LDA playerLocationX
    SEC
    ; SBC #$04 ; sprite W   
    CMP enemyX ;, X ;enemyX
    BPL dumpCheckSpriteCollison 

    ;checking if player is on left edge
    LDA playerLocationX
    ; CLC
    ; ADC #$08
    ; SBC #$04 ; sprite W
    CMP enemyX ;, X ;enemyX
    BMI dumpCheckSpriteCollison

    ; checking if player is above
    LDA playerLocationY ; greater > lesser ==> pass
    CLC
    ; ADC #$08
    ; SBC #$04 ; sprite H
    CMP enemyY ;, X
    BMI dumpCheckSpriteCollison

    ; checking if player is below
    LDA enemyY
    CLC
    ; ADC enemyH
    ; ADC #$08
    ; SBC #$04 ; sprite H
    CMP playerLocationY
    BMI dumpCheckSpriteCollison

    ; LDA #$00
    ; STA collisionFlag
    JSR soundBallCollisionWall

dumpCheckSpriteCollison:
   
    RTS
  
;; this loop won't work because it will only stop if it's the last one.
;; so i might need to invert this whole thing