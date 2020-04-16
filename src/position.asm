.segment "CODE"
updatePosition:

  LDA playerLocationXBuffer
  STA collisionTestX

  LDA playerLocationYBuffer
  STA collisionTestY

  LDA controllerBits

  AND #CONTROL_P1_UP ;UP
  BEQ dumpControlUp ; dumps if we have no A push
  JSR moveUp

dumpControlUp:
  LDA controllerBits

  AND #CONTROL_P1_DOWN ;DOWN
  BEQ dumpControlDown ; dumps if we have no UP push
  JSR moveDown
dumpControlDown:

  LDA controllerBits

  AND #CONTROL_P1_LEFT ;LEFT
  BEQ dumpControlLeft ; dumps if we have no DOWN push
  JSR moveLeft
 
dumpControlLeft:
  LDA controllerBits

  AND #CONTROL_P1_RIGHT ;RIGHT
  BEQ dumpUpdatePosition ; dumps if we have no LEFT push
  JSR moveRight
  
dumpUpdatePosition:

    LDA playerLocationX
    STA $0203 ; place in RAM where the sprite Y is controlled

    LDA playerLocationY
    STA $0200 ; place in RAM where the sprite X is controlled

    LDA #00
    STA controllerBits
    RTS



moveRight:
        LDX #$00
        LDA playerLocationX
        CMP #$ff                ;; CHECK COLLISION
        BCS dumpMoveRight
        CLC
        ADC #$08
        STA playerLocationXBuffer
        STA collisionTestX

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveRight ; branch if 0
        
        LDA playerLocationXBuffer
        STA playerLocationX

        ; JSR nextEnemyMovement ;; trying something here

        RTS
dumpMoveRight:
        LDA playerLocationX
        STA playerLocationXBuffer
        RTS

moveLeft:
        LDX #$00
        LDA #$00                ;; CHECK COLLISION
        CMP playerLocationX
        BCS dumpMoveLeft
        LDA playerLocationX
        SEC
        SBC #$08
        STA playerLocationXBuffer
        STA collisionTestX

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveLeft ; branch if 0

        LDA playerLocationXBuffer
        STA playerLocationX

        ; JSR nextEnemyMovement ;; trying something here

        RTS
dumpMoveLeft:
        LDA playerLocationX
        STA playerLocationXBuffer
        RTS


moveUp:
        LDX #$00
        LDA #$00                ;; CHECK COLLISION
        CMP playerLocationY
        BCS dumpMoveUp

        LDA playerLocationY
        SEC
        SBC #$08
        STA playerLocationYBuffer
        STA collisionTestY

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveUp ; branch if 0

        LDA playerLocationYBuffer
        STA playerLocationY
        RTS
dumpMoveUp:
        LDA playerLocationY
        STA playerLocationYBuffer
        RTS


moveDown:
        LDX #$00
        LDA playerLocationY               ;; CHECK COLLISION
        CMP #$d0
        BCS dumpMoveDown

        LDA playerLocationY
        CLC
        ADC #$08
        STA playerLocationYBuffer
        STA collisionTestY

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveDown ; branch if 0
        
        LDA playerLocationYBuffer
        STA playerLocationY
        RTS
dumpMoveDown:
        LDA playerLocationY
        STA playerLocationYBuffer
        RTS



playerOffset = $08
enemyOffset = $08

checkCollision:
    ; set the collision flag to 0 -- or false
    LDA #$00         ; 0 means there is a collision
    STA collisionFlag
    LDX #$00

checkBackgroundCollisionLoop:

    ; find 
    ; use a grid system so we can make this easy and only check 255 items
    ; or 960 items
    ; i have the X/Y coordinate for the 
    ; can get the index by dividing by 8
    ; fetch the metatitle index and do a compare?
    ; how does this scale to a 16x16 pixel meta tile?


    ;LDA meta_tile0, X
    ;CMP #$02
    ;BEQ dumpCheckBackgroundCollisions

    ; put lower byte into RAM
    ; then store the high byte into X

    ; fills out pointer for 
    LDA #<meta_tile0
    STA collisionPointerLo
    LDA #>meta_tile0
    STA collisionPointerHi

    ; calculates grid position for X (should only be 8-bit)
    CLC
    LDA collisionTestX ; playerPosition in the buffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridX ; converts to grid

    ; stores 0 into pointer
    LDA #$00
    STA playerPointerLo
    STA playerPointerHi

m1:
    ;calculates the grid position for Y (16-bit)
    ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across 

    ; short cutting this because I shouldn't have a carry
    CLC
    LDA playerPointerHi 
    ASL                    ; needed to multiply the high byte
    STA playerPointerHi

    CLC
    LDA collisionTestY ; 8 pixels ; player Y in buffer
    ASL ; Fist x2
    STA playerPointerLo ; saves the low byte
    LDA #$00
    ADC playerPointerHi
    STA playerPointerHi
    
    ; BCC m2 ; branch on carry clear
    ; INC playerPointerHi

m2:
    LDA playerPointerHi 
    ASL                    ; needed to multiply the high byte
    STA playerPointerHi

    LDA playerPointerLo
    ASL ; Second x2
    STA playerPointerLo
        LDA #$00
    ADC playerPointerHi
    STA playerPointerHi
    ; BCC dumpFirstMult ; branch on carry clear
    ; INC playerPointerHi

; what does this mean?
dumpFirstMult:
    
    LDA playerPointerLo
    CLC
    ADC playerGridX
    STA playerPointerLo
    BCC dumpSecondMult   
    INC playerPointerHi

dumpSecondMult:
    
    LDA playerPointerLo ; loads the low byte of where the player is
    CLC 
    ADC collisionPointerLo ; adds to the collision pointer?
    STA backgroundPointerLo ; saves into the background pointer
    LDA playerPointerHi ; loads the player high byte
    ADC collisionPointerHi ; adds to high
    STA backgroundPointerHi ; saves to high

    LDY #$00 ; resets Y
    LDA (backgroundPointerLo), Y ; probably don't need to index this, but I do, why?
    ; I do, this is indirect, I think I have to do it this way
    CMP #$02 ;; whatever are loading it's all 0s
    BNE collide


; this is actually doing something
; but it's not right
; let's get rid of the X loop
checkCollisionSprites:
    LDX #$00
checkCollisionLoop:

    ; SHORT CIRCUIT ;
    JMP allowPass

    ; spriteW = #$04
    LDY #$04

    ; ENEMY CHECK
    ; checking if player is on right edge
    LDA enemyX
    CLC
    ADC #$04 ; sprite W
    CMP collisionTestX
    BMI allowPass ; should want this

    LDA collisionTestX
    SEC
    SBC #$04 ; sprite W   
    CMP enemyX ;, X ;enemyX
    BPL allowPass ; should want this

    ;checking if player is on left edge
    LDA collisionTestX
    ; CLC
    ; ADC #$08
    ; SBC #$04 ; sprite W
    CMP enemyX ;, X ;enemyX
    BMI allowPass ; should want this

    ; checking if player is above
    LDA enemyY ; greater > lesser ==> pass
    CLC
    ADC #$08
    SBC #$04 ; sprite H
    CMP enemyY ;, X
    BMI allowPass ; should want this

    ; checking if player is below
    LDA enemyY
    CLC
    ; ADC enemyH
    ADC #$08
    SBC #$04 ; sprite H
    CMP collisionTestY
    BMI allowPass ; should want this

    LDA #$00
    STA collisionFlag
   
    RTS
  
;; this loop won't work because it will only stop if it's the last one.
;; so i might need to invert this whole thing

allowPass:

    INX
    INX
    INX
    INX

    ; CPX #$18
    ; BMI checkCollisionLoop

    LDA #$01
    STA collisionFlag
    RTS


collide:
    LDA #$00
    STA collisionFlag
    RTS

