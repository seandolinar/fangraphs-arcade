.segment "CODE"
updatePosition:
  LDA controllerBits
  AND #CONTROL_P1_UP ;UP
  BEQ dumpControlUp ; dumps if we have no A push
  JSR moveUp
dumpControlUp:
  LDA controllerBits
  AND #CONTROL_P1_DOWN ;UP
  BEQ dumpControlDown ; dumps if we have no A push
  JSR moveDown
dumpControlDown:
  LDA controllerBits
  AND #CONTROL_P1_LEFT ;UP
  BEQ dumpControlLeft ; dumps if we have no A push
  JSR moveLeft
 
dumpControlLeft:
  LDA controllerBits
  AND #CONTROL_P1_RIGHT ;UP
  BEQ dumpUpdatePosition ; dumps if we have no A push
  JSR moveRight
  
dumpUpdatePosition:

    LDA playerLocationX
    STA $0203

    LDA playerLocationY
    STA $0200

    ;LDA enemyX
    ;STA $0204

    ;LDA enemyY
    ;STA $0207
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

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveRight ; branch if 0
        
        LDA playerLocationXBuffer
        STA playerLocationX
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

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveLeft ; branch if 0

        LDA playerLocationXBuffer
        STA playerLocationX
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

    LDA playerLocationYBuffer
    ASL ;mult x 2
    STA playerGridY

    LDA playerLocationXBuffer
    LSR ; divide / 2
    LSR
    LSR
    STA playerGridX

    CLC
    ADC playerGridY

    STA playerPointerLo
    LDA #$00
    ADC playerPointerHi
    
    LDA playerPointerLo
    CLC 
    ADC collisionPointerLo
    STA collisionPointerLo
    LDA playerPointerHi
    ADC playerPointerHi
    STA collisionPointerHi

    LDY #$00
    LDA (collisionPointerLo),Y
    CMP #$ff
    BEQ checkCollisionSprites
    CMP #$00 ;; whatever are loading it's all 0s
    BNE collide


;dumpCheckBackgroundCollisions:
 ;   INX
  ;  JMP checkBackgroundCollisionLoop

checkCollisionSprites:
    LDX #$00
checkCollisionLoop:

    ; checking if player is on right edge
    LDA enemy_array + 2, X
    CLC
    ADC enemyW    
    CMP playerLocationXBuffer
    BMI allowPass ; should want this

    LDA playerLocationXBuffer
    SEC
    SBC enemyW    
    ;ADC #$01
    CMP enemy_array + 2, X ;enemyX
    BPL allowPass ; should want this

    ; checking if player is on left edge
    LDA playerLocationXBuffer
    CLC
    ADC #$08
    SBC #$01
    CMP enemy_array + 2, X ;enemyX
    BMI allowPass ; should want this

    ; checking if player is above
    LDA playerLocationYBuffer ; greater > lesser ==> pass
    CLC
    ADC #$08
    SBC #$01
    CMP enemy_array + 1, X
    BMI allowPass ; should want this

    ; checking if player is below
    LDA enemy_array + 1, X
    CLC
    ADC enemyH
    SBC #$01
    CMP playerLocationYBuffer
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

    CPX #$18
    BMI checkCollisionLoop

    LDA #$01
    STA collisionFlag
    RTS


collide:
    LDA #$00
    STA collisionFlag
    RTS

