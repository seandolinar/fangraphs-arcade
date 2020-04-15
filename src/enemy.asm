
nextEnemyMovement:
 
    LDA enemyX
    JSR pickDirection ; should use the acculumator
    ; SEC
    ; SBC #$04
    STA enemyXBuffer

    LDA enemyY
    JSR pickDirection
    STA enemyYBuffer

    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    STA consoleLogEnemyCollision
    BNE dumpEnemyController


    ; move this somewhere else
    CLC
    LDA enemyYBuffer
    STA enemyY
    STA $0204 ; sprite RAM x

    CLC
    LDA enemyXBuffer
    STA enemyX
    STA $0207 ; sprite RAM y


dumpEnemyController:
    RTS


;; working on this
newCheckBackgroundCollisionEnemy:
    ; this was working before beause we never set the collionsFlagEnemy
    ; now it's outputting 4
    ; which prevents it from moving

    LDA #$00
    STA collisionFlagEnemy

    LDA #<meta_tile0
    STA collisionPointerLoEnemy
    LDA #>meta_tile0
    STA collisionPointerHiEnemy

    CLC
    LDA enemyXBuffer
    LSR ; divide / 2 / 2 / 2
    LSR
    LSR
    STA enemyGridX ; finds spot on grid

    LDA #$00
    STA enemyPointerLo
    STA enemyPointerHi

    CLC
    LDA collisionTestY ; 8 pixels ; player Y in buffer
    ASL ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across 
    ; why is this only x2 instead of x4?
    STA enemyPointerLo 
    LDA #$00
    ADC #$00
    STA enemyPointerHi

    LDA enemyPointerLo
    ASL ; this is where the second x2 is coming in? because I have to carry?
    STA enemyPointerLo
    BCC dumpFirstMultEnemy ; branch on carry clear
    INC enemyPointerHi

dumpFirstMultEnemy:

    LDA enemyPointerLo
    CLC
    ADC enemyGridX
    STA enemyPointerLo
    BCC dumpSecondMultEnemy
    INC enemyPointerHi

dumpSecondMultEnemy:

    ; i'm beginning to question all of this
    LDA enemyPointerLo ; loads the low byte of where the player is
    CLC 
    ADC collisionPointerLoEnemy ; adds to the collision pointer?
    STA backgroundPointerLo ; saves into the background pointer
    LDA enemyPointerHi ; loads the player high byte
    ADC collisionPointerHiEnemy ; adds to high
    STA backgroundPointerHi ; saves to high

    LDY #$00 ; resets Y
    LDA (backgroundPointerLo), Y ; i'm getting 1 here
    ; I do, this is indirect, I think I have to do it this way
        ; STA consoleLogEnemyCollision
    STA consoleLogEnemyCollision 

    CMP #$02 ;; whatever are loading it's all 0s
    BNE collideEnemy ; branch if cmp is not equal to A
    LDA #$0e
    STA consoleLogEnemyCollision
    RTS

collideEnemy:
    LDA #$01
    STA collisionFlagEnemy
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
;     CLC
;     LDA enemyX
;     LSR ; divide / 2 / 2 / 2
;     LSR
;     LSR
;     STA enemyGridX

;     ; stores 0 into pointer
;     LDA #$00
;     STA enemyPointerLo
;     STA enemyPointerHi

;     ;calculates the grid position for Y (16-bit)

;     CLC
;     LDA enemyY              ; 8 pixels
;     ASL                     ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across
;     STA enemyPointerLo 
;     LDA #$00
;     ADC #$00
;     STA enemyPointerHi 

;     LDA enemyPointerLo
;     ASL
;     STA enemyPointerLo
;     BCC dumpFirstMultEnemy
;     INC enemyPointerHi

; dumpFirstMultEnemy:
;     LDA playerPointerLo
;     CLC
;     ADC enemyGridX
;     STA enemyPointerLo
;     BCC dumpSecondMultEnemy
;     INC enemyPointerHi

; dumpSecondMultEnemy:
    
;     LDA enemyPointerLo ; loads the low byte of where the enemy is
;     CLC 
;     ADC collisionPointerLoEnemy
;     STA backgroundPointerLo ;backgroundPointerLoEnemy
;     LDA enemyPointerHi ; loads the player high byte
;     ADC collisionPointerHi
;     STA backgroundPointerHiEnemy


;     ;;; DEBUG this is making collisionFlagEnemy = 1
;     ;;; though we are starting _IN_ a wall
;     LDY #$00
;     LDA (backgroundPointerLo), Y ;(backgroundPointerLoEnemy), Y
;     LDA #$02 ;; changed this
;     CMP #$02                            ;; whatever are loading it's all 0s ; clear items are $02???
;     BNE collideEnemy
  
; allowPassEnemy:
;     LDA #$00
;     STA collisionFlagEnemy
;     RTS

; collideEnemy:
;     LDA #$01
;     STA collisionFlagEnemy
;     RTS



pickDirection:
    LDX enemyQ
    CPX #$0b
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
    ADC #$08
    RTS

; the branched $00 option 
pickDirectionReverse:
    SEC
    SBC #$08
    RTS

   

    

    