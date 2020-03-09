
nextEnemyMovement:
 
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
    STA collisionPointerLoEnemy
    LDA #>meta_tile0
    STA collisionPointerHiEnemy

    ; calculates grid position for X (should only be 8-bit)
    ; CLC
    ; LDA enemyX1
    ; LSR ; divide / 2 / 2 / 2
    ; LSR
    ; LSR
    ; STA enemyGridX

    ; stores 1 into pointer
    LDA #$00
    STA enemyPointerLo
    STA enemyPointerHi

    ;calculates the grid position for Y (16-bit)

    CLC
    LDA enemyY1 ; 8 pixels
    ASL ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across
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
    
    LDA enemyPointerLo ; loads the low byte of where the player is
    CLC 
    ADC collisionPointerLoEnemy
    STA backgroundPointerLoEnemy
    LDA enemyPointerHi ; loads the player high byte
    ADC collisionPointerHi
    STA backgroundPointerHiEnemy

    LDY #$00
    LDA (backgroundPointerLoEnemy), Y
    CMP #$02 ;; whatever are loading it's all 0s
    BNE collideEnemy
    LDA #$01
    ; STA collisionFlagEnemy

    RTS

collideEnemy:
    LDA #$00
    ; STA collisionFlagEnemy
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

    ; branches if Y is $00
    BEQ pickDirectionReverse
    INX

; if Y is $01 we run this
pickDirectionForward:
    CLC
    ADC #$04
    RTS

; the branched $00 option 
pickDirectionReverse:
    SBC #$04
    RTS

   

    

    