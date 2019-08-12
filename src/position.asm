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

    LDA #$01         ; 0 means 
    STA collisionFlag

    LDA playerLocationX
    STA $0203

    LDA playerLocationY
    STA $0200

    LDA enemyX
    STA $0204

    LDA enemyY
    STA $0207

    RTS

moveRight:
        LDA playerLocationX
        CMP #$80                ;; CHECK COLLISION
        BCS dumpMoveRight

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveRight ; branch if 0
        
        LDA playerLocationX
        CLC
        ADC #$01
        STA playerLocationX
dumpMoveRight:
        RTS

moveLeft:
        LDA #$08                ;; CHECK COLLISION
        CMP playerLocationX
        BCS dumpMoveLeft

    ;checkEnemyX:
     ;   LDX #$01
      ;  LDA enemyX
       ; CLC
      ;  ADC enemyH
       ; CMP playerLocationX
      ;  BCS dumpMoveLeft
      ;  DEX
      ;  BNE checkEnemyX
        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveLeft ; branch if 0

        LDA playerLocationX
        SEC
        SBC #$01
        STA playerLocationX
dumpMoveLeft:
        RTS


moveUp:
        LDA #$08                ;; CHECK COLLISION
        CMP playerLocationY
        BCS dumpMoveUp

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveUp ; branch if 0

        LDA playerLocationY
        SEC
        SBC #$01
        STA playerLocationY
dumpMoveUp:
        RTS


moveDown:
        LDA playerLocationY               ;; CHECK COLLISION
        CMP #$d0
        BCS dumpMoveDown

        JSR checkCollision
        LDA collisionFlag
        BEQ dumpMoveDown ; branch if 0
        
        LDA playerLocationY
        CLC
        ADC #$01
        STA playerLocationY
dumpMoveDown:
        RTS



playerOffset = $08
enemyOffset = $08
checkCollision:
    

    ; checking if player is on right edge
    LDA enemyX
    CLC
    ADC enemyW
    CMP playerLocationX
    BMI allowPass ; should want this

    ; checking if player is on left edge
    LDA playerLocationX
    CLC
    ADC #$08
    CMP enemyX
    BMI allowPass ; should want this

    ; checking if player is above
    LDA playerLocationY ; greater > lesser ==> pass
    CLC
    ADC #$08
    CMP enemyY
    BMI allowPass ; should want this

    ; checking if player is below
    LDA enemyY ; 
    CLC
    ADC enemyH
    CMP playerLocationY
    BMI allowPass ; should want this



    RTS


allowPass:
    LDA #$01
    STA collisionFlag
    RTS