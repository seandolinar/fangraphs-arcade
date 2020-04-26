nextEnemyMovement:
    LDX #$01            ; how many enemyies we have
    LDY #$00
forEachEnemyMovement:
    DEX

enemyMovement:
    LDA enemyX, X
    STA enemyXBuffer
    STA enemyXWork

    LDA enemyY, X
    STA enemyYBuffer
    STA enemyYWork

    JSR pickDirectionNew2 

    dumpEnemyMovement:
       
    moveHorizontal:
        CLC
        LDA enemyXBuffer
        STA enemyX, X
        STA enemy_oam + 3, Y ; sprite RAM x

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

changeEnemyColor:

    TXA
    PHA
    TYA
    PHA

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

    PLA
    TAY
    PLA
    TAX

    RTS

   
changeEnemyColorPowerUp:
    LDA #%0000011 ; POWER UP STATE ; RED
    JMP changeEnemyColorLoop


; using this to rotate through the enemy "random" counter
setEnemyQ:
    INC enemyQ              ; increments are randomizers
    LDA enemyQ
    CMP #$0a                ; if we are at value 12 dump out, we're good
    BNE @dump
    LDA #$00                ; reset to 0 if we reach 12
    STA enemyQ
    @dump:
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

    TYA                             ; use Y for the randomizer
    PHA
    JSR setEnemyQ
    LDY enemyQ
    
    TXA
    PHA
    LDX #$00                        ; initialize X for array length

    LDA enemy1DirectionCurrent      ; going to have to change this for multiples
    CMP #$01 ; TODO: make these constants
    BEQ dumpAvailableUp
    CMP #$02
    BEQ dumpAvailableDown
    CMP #$03
    BEQ dumpAvailableLeft
    JMP dumpAvailableRight ; not a great work around 

    dumpAvailableUp:
        @checkUp:
        JSR enemyMoveUp
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @checkLeft
        LDA #$01
        PHA
        INX

        @checkLeft:
        JSR enemyMoveLeft
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @checkRight
        LDA #$03
        PHA
        INX

        @checkRight:
        JSR enemyMoveRight
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @dump
        LDA #$04
        PHA
        INX

        @dump:
        JMP chooseFromAvailableDirections

    dumpAvailableDown:
        @checkDown:
        JSR enemyMoveDown
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
        BNE @checkLeft
        LDA #$02
        PHA
        INX

        @checkLeft:
        JSR enemyMoveLeft
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @checkRight
        LDA #$03
        PHA
        INX

        @checkRight:
        JSR enemyMoveRight
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @dump
        LDA #$04
        PHA
        INX

        @dump:
        JMP chooseFromAvailableDirections

    dumpAvailableLeft:
        @checkUp:
        JSR enemyMoveUp
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
        BNE @checkDown
        LDA #$01
        PHA
        INX

        @checkDown:
        JSR enemyMoveDown
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
        BNE @checkLeft
        LDA #$02
        PHA
        INX

        @checkLeft:
        JSR enemyMoveLeft
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
        BNE @dump
        LDA #$03
        PHA
        INX
    
        @dump:
        JMP chooseFromAvailableDirections

    dumpAvailableRight:
        @checkUp:
        JSR enemyMoveUp
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
        BNE @checkDown
        LDA #$01
        PHA
        INX

        @checkDown:
        JSR enemyMoveDown
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @checkRight
        LDA #$02
        PHA
        INX

        @checkRight:
        JSR enemyMoveRight
        JSR newCheckBackgroundCollisionEnemy
        LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
        BNE @dump
        LDA #$04
        PHA
        INX

        @dump:

    chooseFromAvailableDirections:

    ; resetting buffer
    ; DEBUGGING
    LDA enemyXWork
    STA enemyXBuffer
    LDA enemyYWork
    STA enemyYBuffer

    LDA enemy_direction_3, Y
    STA enemyCMPTemp

    ; Loops so that we remove the stack pushes we did...variable length array
    ; X is the length of the array
    @loop:
    CPX #$00
    BEQ @dumpLoop
    PLA

    ; CODE that evaluates the direction into the enemyX/Y buffer
    ; CODE that figures out the distance between two points
    ; CODE that compares the two values

    ; FOR NOW we are going to try a random 1 or 2
    ; use Y

    CPX enemyCMPTemp                    ; figure out this variable
    BNE @continueLoop                   ; continue if we don't equal

    CMP #$01
    BEQ @moveUp

    CMP #$02
    BEQ @moveDown

    CMP #$03
    BEQ @moveLeft

    CMP #$04
    BEQ @moveRight

    JMP @continueLoop

    @moveUp:
    JSR enemyMoveUp
    LDA #$01
    STA enemy1DirectionCurrent

    LDA #$07
    STA consoleLogEnemyCollision
    JMP @continueLoop

    @moveDown:
    JSR enemyMoveDown
    LDA #$02
    STA enemy1DirectionCurrent

    ; LDA #$09
    ; STA consoleLogEnemyCollision

    JMP @continueLoop

    @moveLeft:
    JSR enemyMoveLeft
    LDA #$03
    STA enemy1DirectionCurrent
    LDA #$07
    STA consoleLogEnemyCollision
    JMP @continueLoop

    @moveRight:
    JSR enemyMoveRight
    LDA #$04
    STA enemy1DirectionCurrent
    LDA #$07
    STA consoleLogEnemyCollision
    JMP @continueLoop

    @continueLoop:
    DEX
    JMP @loop

    @dumpLoop:
    PLA
    TAX

    PLA
    TAY

    RTS

enemyMoveUp:
    LDA enemyXWork
    STA enemyXBuffer
    SEC
    LDA enemyYWork
    SBC #$08
    STA enemyYBuffer
    RTS

enemyMoveDown:
    LDA enemyXWork
    STA enemyXBuffer
    CLC
    LDA enemyYWork
    ADC #$08
    STA enemyYBuffer
    RTS

enemyMoveLeft:
    LDA enemyYWork
    STA enemyYBuffer
    SEC
    LDA enemyXWork
    SBC #$08
    STA enemyXBuffer
    RTS

enemyMoveRight:
    LDA enemyYWork
    STA enemyYBuffer
    CLC
    LDA enemyXWork
    ADC #$08
    STA enemyXBuffer
    RTS