
nextEnemyMovement:

    LDX #$02
forEachEnemyMovement:
    DEX

    LDA enemyX, X
    JSR pickDirection ; should use the acculumator
    STA enemyXBuffer

    LDA enemyY, X
    JSR pickDirection
    STA enemyYBuffer

    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    STA consoleLogEnemyCollision
    BNE dumpEnemyController


    ; move this somewhere else
    CLC
    LDA enemyYBuffer
    STA enemyY, X
    STA $0204 ; sprite RAM x

    CLC
    LDA enemyXBuffer
    STA enemyX, X
    STA $0207 ; sprite RAM y

    CPX #$00
    BNE forEachEnemyMovement


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

    ; stores 0 into pointer
    LDA #$00
    STA enemyPointerLo
    STA enemyPointerHi

me1:

    ; short cutting this because I shouldn't have a carry
    ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across 
    CLC
    LDA enemyPointerHi 
    ASL                    ; needed to multiply the high byte
    STA enemyPointerHi

    CLC
    LDA enemyYBuffer ; 8 pixels ; player Y in buffer
    ASL 
    STA enemyPointerLo 
    LDA #$00
    ADC enemyPointerHi
    STA enemyPointerHi

    ; LDA enemyPointerLo
    ; ASL ; this is where the second x2 is coming in? because I have to carry?
    ; STA enemyPointerLo
    ; BCC dumpFirstMultEnemy ; branch on carry clear
    ; INC enemyPointerHi

me2:
    LDA enemyPointerHi 
    ASL                    ; needed to multiply the high byte
    STA enemyPointerHi

    LDA enemyPointerLo
    ASL ; Second x2
    STA enemyPointerLo
    LDA #$00
    ADC enemyPointerHi
    STA enemyPointerHi


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

pickDirection:
    ; TXS ; stack is causing crashes
    STX tempX
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
    ; ADC #$08
    LDX tempX
    RTS

; the branched $00 option 
pickDirectionReverse:
    SEC
    ; SBC #$08
    LDX tempX
    RTS

   

    

    