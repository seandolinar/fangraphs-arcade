
nextEnemyMovement:

    LDX #$02
    LDY #$00
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

    ; OAM
    ; 00 -- Player, 00:Y, 01:tile, 02:attr, 03:X 
    ; 04 -- Enemy1, 04:Y, 05:tile, 06:attr, 07:X
    ; 08 -- Enemy2, 08:Y, 09:tile, 09:attr, 0A:X
    ; move this somewhere else
    LDY tempY
    CLC
    LDA enemyYBuffer
    STA enemyY, X
    STA enemy_oam, Y ; sprite RAM y

    CLC
    LDA enemyXBuffer
    STA enemyX, X
    STA enemy_oam + 3, Y ; sprite RAM x

    INY
    INY
    INY
    INY

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

    STY tempY
    LDY #$00 ; resets Y
    LDA (backgroundPointerLo), Y ; i'm getting 1 here
    ; I do, this is indirect, I think I have to do it this way
        ; STA consoleLogEnemyCollision
    STA consoleLogEnemyCollision
    LDY tempY 

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
    
    STY tempY

    LDY enemy_direction_random, X
    CPY #$FF
    BEQ pickDirectionReverse  ; branches if Y is $00
    CPY #$01
    BEQ pickDirectionForward  ; branches if Y is $00

    INX

; if Y is $01 we run this
; the CLC and SEC make this work right
pickDirectionForward:
    CLC
    ADC #$08
    LDX tempX
    LDY tempY
    RTS

; the branched $00 option 
pickDirectionReverse:
    SEC
    SBC #$08
    LDX tempX
    LDY tempY
    RTS


changeEnemyColor:

    STX tempX
    STY tempY

    LDX #$02
    LDY #$00

    LDA gameStateIsPowered
    BNE changeEnemyColorPowerUp ; BNE branches if we LDA a #$00

    LDA #%0000001 ; yellow

changeEnemyColorLoop:
    DEX 
    STA enemy_oam + 2, Y

    INY
    INY
    INY
    INY

    CPX #$00
    BNE changeEnemyColorLoop

    LDX tempX
    LDY tempY
    RTS

   
changeEnemyColorPowerUp:
    LDA #%0000011 ; POWER UP STATE ; RED
    JMP changeEnemyColorLoop

    

    