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
                                    ; this affects the subs...guh not very well "scoped"

    LDA enemy1DirectionCurrent      ; going to have to change this for multiples
    CMP #$01 ; TODO: make these constants
    BEQ dumpAvailableUp
    CMP #$02
    BEQ dumpAvailableDown
    CMP #$03
    BEQ dumpAvailableLeft
    JMP dumpAvailableRight ; not a great work around 

    dumpAvailableUp:
        JSR subAvailableUp
        JMP chooseFromAvailableDirections

    dumpAvailableDown:
        JSR subAvailableDown
        JMP chooseFromAvailableDirections
        
    dumpAvailableLeft:
        JSR subAvailableLeft
        JMP chooseFromAvailableDirections

    dumpAvailableRight:
        JSR subAvailableRight
        JMP chooseFromAvailableDirections

chooseFromAvailableDirections:

    ; resetting buffer
    ; DEBUGGING
    LDA enemyXWork
    STA enemyXBuffer
    LDA enemyYWork
    STA enemyYBuffer

    LDA enemy_direction_3, Y
    STA enemyCMPTemp

    STX enemyTempForLoop ; move this?
    LDX #$00
    
    ; Loops so that we remove the stack pushes we did...variable length array
    ; X is the length of the array
    ; X is from the subAvailable[Direction] subroutine
    @loop:
    CPX enemyTempForLoop ; this might be one short
    BEQ @dumpLoop
    LDA enemyDirectionArray, X ; i was inverting this


    ; CODE that evaluates the direction into the enemyX/Y buffer
    ; CODE that figures out the distance between two points
    ; CODE that compares the two values

    ; FOR NOW we are going to try a random 1 or 2
    ; use Y



    ;;; PICK DIRECTION
    ; CPX enemyCMPTemp                    ; figure out this variable
    ; BNE @continueLoop                   ; continue if we don't equal

    CMP #$01
    BEQ @moveUp

    CMP #$02
    BEQ @moveDown

    CMP #$03
    BEQ @moveLeft

    CMP #$04
    BEQ @moveRight
    ;;; PICK DIRECTION
    
    JMP @continueLoop

    @moveUp:
    JSR enemyMoveUp
    LDA #$01
    STA enemy1DirectionCurrent

    JMP @continueLoop

    @moveDown:
    JSR enemyMoveDown
    LDA #$02
    STA enemy1DirectionCurrent

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
    ; DEX
    INX
    JMP @loop

    @dumpLoop:
    PLA                 ; put X/Y back
    TAX

    PLA
    TAY

    RTS

subAvailableUp:
    ; I'm not resetting X going into here.
    ; We need X coming out of here
    @checkUp:
    JSR enemyMoveUp
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkLeft
    
    ; JSR absX                                ; hopefully loop this
    ; LDA enemyAbsX
    ; STA sqIn                                ; change this? would need to be 16-bit
    ; JSR computeSquare
    ; LDA sqOut
    ; STA enemyDistance
    ; LDA sqOut + 1
    ; STA enemyDistance + 1

    ; JSR absY
    ; STA sqIn                                ; change this? would need to be 16-bit
    ; JSR computeSquare

    ; CLC
    ; LDA sqOut
    ; ADC enemyDistance
    ; STA enemyDistance

    ; CLC
    ; LDA sqOut + 1
    ; ADC enemyDistance + 1
    ; STA enemyDistance + 1

    JSR computeDistance1

    LDA #$01
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight
    LDA #$03
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump
    LDA #$04
    ; PHA
    STA enemyDirectionArray, X
    INX

    @dump:
    RTS

subAvailableDown:
    @checkDown:
    JSR enemyMoveDown
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkLeft

    JSR computeDistance1

    LDA #$02
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight
    LDA #$03
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump
    LDA #$04
    ; PHA
    STA enemyDirectionArray, X
    INX

    @dump:
    RTS

subAvailableLeft: 
    @checkUp:
    JSR enemyMoveUp
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkDown

    JSR computeDistance1

    LDA #$01
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkLeft
    LDA #$02
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @dump
    LDA #$03
    ; PHA
    STA enemyDirectionArray, X
    INX

    @dump:
    RTS

subAvailableRight:
    @checkUp:
    JSR enemyMoveUp
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkDown

    JSR computeDistance1

    LDA #$01
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight
    LDA #$02
    ; PHA
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump
    LDA #$04
    ; PHA
    STA enemyDirectionArray, X
    INX

    @dump:
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


absX:
    LDA enemyXBuffer
    CMP playerLocationX
    BCS @subtractSwap                    ; if enemyX is greater than playerLocationX

    @subtractNormal:
    SEC
    LDA playerLocationX
    SBC enemyXBuffer

    @subtractSwap:
    SEC
    LDA enemyXBuffer
    SBC playerLocationX

    STA enemyAbsX

    RTS

absY:
    LDA enemyYBuffer
    CMP playerLocationY
    BCS @subtractSwap                    ; if enemyX is greater than playerLocationX

    @subtractNormal:
    SEC
    LDA playerLocationY
    SBC enemyYBuffer

    @subtractSwap:
    SEC
    LDA enemyYBuffer
    SBC playerLocationY

    STA enemyAbsY

    RTS

computeSquare:
    TXA
    PHA

    LDX sqIn
    LDA sqIn

    STA sqOut
    LDA #$00
    STA sqOut + 1

    CLC
    DEX
    @additionLoop:
    LDA sqOut               ; low byte
    ADC sqIn
    STA sqOut

    LDA sqOut + 1           ; high byte
    ADC #$00
    STA sqOut + 1

    DEX
    BNE @additionLoop

    PLA
    TAX

    RTS

computeDistance1:
    JSR absX                                ; hopefully loop this
    LDA enemyAbsX
    STA sqIn                                ; change this? would need to be 16-bit
    JSR computeSquare
    LDA sqOut
    STA enemyDistance
    LDA sqOut + 1
    STA enemyDistance + 1

    JSR absY
    STA sqIn                                ; change this? would need to be 16-bit
    JSR computeSquare

    CLC
    LDA sqOut
    ADC enemyDistance
    STA enemyDistance

    CLC
    LDA sqOut + 1
    ADC enemyDistance + 1
    STA enemyDistance + 1

    RTS