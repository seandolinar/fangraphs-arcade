
nextEnemyMovement:

    LDX #$01            ; how many enemyies we have
    LDY #$00
forEachEnemyMovement:
    DEX

enemyMovement:
    LDA enemyX, X
    STA enemyXBuffer

    LDA enemyY, X
    STA enemyYBuffer

    JSR pickDirectionNew ; I can probably change this
    LDA enemyNextDirection
    STA enemy1DirectionCurrent, X
    CMP #$01 ;;
    BEQ enemyMoveUp ;enemyMoveLeft
    CMP #$02
    BEQ enemyMoveDown ;enemyMoveRight
    CMP #$03
    BEQ enemyMoveLeft ;enemyMoveDown
    CMP #$04
    BEQ enemyMoveRight ;enemyMoveUp

    enemyMoveUp:
        SEC
        LDA enemyY, X
        SBC #$08
        STA enemyYBuffer
        JMP dumpEnemyMovement

    enemyMoveDown:
        CLC
        LDA enemyY, X
        ADC #$08
        STA enemyYBuffer
        JMP dumpEnemyMovement

    enemyMoveLeft:
        SEC
        LDA enemyX, X
        SBC #$08
        STA enemyXBuffer
        JMP dumpEnemyMovement

    enemyMoveRight:
        CLC
        LDA enemyX, X
        ADC #$08
        STA enemyXBuffer
        JMP dumpEnemyMovement

    



    enemyContinue:
        ; don't know this yet


    dumpEnemyMovement:
        ; JSR newCheckBackgroundCollisionEnemy
        ; LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        ; BNE dumpEnemyController

        ; OAM
        ; 00 -- Player, 00:Y, 01:tile, 02:attr, 03:X 
        ; 04 -- Enemy1, 04:Y, 05:tile, 06:attr, 07:X
        ; 08 -- Enemy2, 08:Y, 09:tile, 09:attr, 0A:X
        ; move this somewhere else

        ; not really liking this logic structure
        LDA enemyNextDirection
        CMP #$01
        BEQ moveVertical
        CMP #$02
        BEQ moveVertical

    moveHorizontal:
        CLC
        LDA enemyXBuffer
        STA enemyX, X
        STA enemy_oam + 3, Y ; sprite RAM x
        JMP dumpEnemyController

           ; LDY tempY
    moveVertical:
        CLC
        LDA enemyYBuffer
        STA enemyY, X
        STA enemy_oam, Y ; sprite RAM y



dumpEnemyController:

        INY
        INY
        INY
        INY
        CPX #$00
        BNE forEachEnemyMovement ; loops for other enemies

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
    LDY tempY 

    CMP #$02 ;; whatever are loading it's all 0s
    BEQ dumpCollideEnemy ; branch if cmp is not equal to A
    CMP #$03
    BEQ dumpCollideEnemy ; branch if cmp is not equal to A

collideEnemy:
    LDA #$01
    STA collisionFlagEnemy
    RTS
dumpCollideEnemy:
    LDA #$0e
    RTS

; pickDirection:
;     ; TXS ; stack is causing crashes
;     STX tempX
;     LDX enemyQ
;     CPX #$0b
;     BCC pickDirectionContinue
;     LDX #$00
    
; pickDirectionContinue:
;     INX
;     STX enemyQ
    
;     STY tempY

;     LDY enemy_direction_random, X
;     CPY #$FF
;     BEQ pickDirectionReverse  ; branches if Y is $00
;     CPY #$01
;     BEQ pickDirectionForward  ; branches if Y is $00

;     INX

; ; if Y is $01 we run this
; ; the CLC and SEC make this work right
; pickDirectionForward:
;     CLC
;     ADC #$08
;     LDX tempX
;     LDY tempY
;     RTS

; ; the branched $00 option 
; pickDirectionReverse:
;     SEC
;     SBC #$08
;     LDX tempX
;     LDY tempY
;     RTS


changeEnemyColor:

    ; STX tempX
    TXA
    PHA
    TYA
    PHA
    ; STY tempY

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

    ; LDX tempX
    PLA
    TAY
    PLA
    TAX
    ; LDY tempY
    RTS

   
changeEnemyColorPowerUp:
    LDA #%0000011 ; POWER UP STATE ; RED
    JMP changeEnemyColorLoop


; build some AI into this?
pickDirectionNew:
    TXA
    PHA
    LDX enemyQ
    CPX #$0a
    BCC pickDirectionNewContinue
    LDX #$00

    pickDirectionNewContinue:
        LDA enemy_multi_direction_random, X
        STA enemyNextDirection
        ; STA consoleLogEnemyCollision
        INX
        STX enemyQ
        
    PLA
    TAX
    RTS
    

; need to check the all four directions
; run through the three directions and collision check
; have to omit the backwards direction
; check direction, dump if we are the opposite
; have available directions
; pick one
; if we only have one, continue

; if we are going up, then we need to check up, left, right
; then pick one of those 
; figure out if I can use the stack here for a loop
pickDirectionNew2:
    LDA enemy1DirectionCurrent      ; going to have to change this for multiples
    CMP #$01
    BEQ dumpAvailableDown


    dumpAvailableDown:



    RTS