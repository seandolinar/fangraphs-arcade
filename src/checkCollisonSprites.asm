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

    LDA gameStateIsPowered
    CMP #$01
    BEQ collisionGood

    JSR soundCollision ; Bad collision
    RTS

collisionGood:
    JSR soundCollisionGood

dumpCheckSpriteCollison:
   
    RTS
  
;; this loop won't work because it will only stop if it's the last one.
;; so i might need to invert this whole thing