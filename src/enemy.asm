
nextEnemyMovement:

    ;;; DEBUG -- We are getting here

    JSR checkBackgroundCollisionEnemy
    LDY collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE dumpEnemyController

    ;;; DEBUG -- Not getting there
    ;;; collisionFlagEnemy is getting set to 1 or > somewhere
    ; LDX consoleLogEnemyCollision
    ; INX
    ; STX consoleLogEnemyCollision
    ; LDA enemyX
    ; STA consoleLogEnemyCollision

  
 
    LDA enemyX
    JSR pickDirection
    STA enemyX

    LDA enemyY
    JSR pickDirection
    STA enemyY


    ; move this somewhere else
    LDA enemyX
    STA $0204 ; sprite RAM x

    LDA enemyY
    STA $0207 ; sprite RAM y



dumpEnemyController:
    RTS



updateEnemyPosition:

RTS


checkBackgroundCollisionEnemy:

    ; set the collision flag to 0 -- or false
    ; LDA #$00         ; 0 means there is a collision
    ; STA collisionFlag
    ; LDX #$00

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

    LDA #$00
    STA collisionFlagEnemy

    ; fills out pointer for 
    LDA #<meta_tile0
    STA collisionPointerLoEnemy
    LDA #>meta_tile0
    STA collisionPointerHiEnemy

    ; calculates grid position for X (should only be 8-bit)
    CLC
    LDA enemyX
    LSR ; divide / 2 / 2 / 2
    LSR
    LSR
    STA enemyGridX

    ; stores 0 into pointer
    LDA #$00
    STA enemyPointerLo
    STA enemyPointerHi

    ;calculates the grid position for Y (16-bit)

    CLC
    LDA enemyY              ; 8 pixels
    ASL                     ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across
    STA enemyPointerLo 
    LDA #$00
    ADC #$00
    STA enemyPointerHi 

    LDA enemyPointerLo
    ASL
    STA enemyPointerLo
    BCC dumpFirstMultEnemy
    INC enemyPointerHi

dumpFirstMultEnemy:
    LDA playerPointerLo
    CLC
    ADC enemyGridX
    STA enemyPointerLo
    BCC dumpSecondMultEnemy
    INC enemyPointerHi

dumpSecondMultEnemy:
    
    LDA enemyPointerLo ; loads the low byte of where the enemy is
    CLC 
    ADC collisionPointerLoEnemy
    STA backgroundPointerLo ;backgroundPointerLoEnemy
    LDA enemyPointerHi ; loads the player high byte
    ADC collisionPointerHi
    STA backgroundPointerHiEnemy


    ;;; DEBUG this is making collisionFlagEnemy = 1
    ;;; though we are starting _IN_ a wall
    LDY #$00
    LDA (backgroundPointerLo), Y ;(backgroundPointerLoEnemy), Y
    LDA #$02
    STA consoleLogEnemyCollision
    CMP #$02                            ;; whatever are loading it's all 0s ; clear items are $02???
    BNE collideEnemy
  
allowPassEnemy:
    LDA #$00
    STA collisionFlagEnemy
    RTS

collideEnemy:
    LDA #$01
    STA collisionFlagEnemy
    RTS



pickDirection:
    LDX enemyQ
    CPX #$08
    BCC pickDirectionContinue
    LDX #$00
    
pickDirectionContinue:
    INX
    STX enemyQ
    LDY enemy_direction_random, X
    BEQ pickDirectionReverse  ; branches if Y is $00
    INX

; if Y is $01 we run this
; the CLC and SEC make this work right
pickDirectionForward:
    CLC
    ADC #$04
    RTS

; the branched $00 option 
pickDirectionReverse:
    SEC
    SBC #$04
    RTS

   

    

    