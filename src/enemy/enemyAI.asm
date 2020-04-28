
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

pickDirection:

    TYA                                 ; use Y for the randomizer
    PHA
    TXA
    PHA
    LDX #$00                            ; initialize X for array length
                                        ; this affects the subs...guh not very well "scoped"

    LDA enemyBufferDirectionCurrent     ; going to have to change this for multiples
    CMP #$01                            ; TODO: make these constants
    BEQ dumpAvailableUp
    CMP #$02
    BEQ dumpAvailableDown
    CMP #$03
    BEQ dumpAvailableLeft
    JMP dumpAvailableRight               ; not a great work around 

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
    LDA enemyXWork
    STA enemyXBuffer
    LDA enemyYWork
    STA enemyYBuffer

    STX enemyTempForLoop ; move this?
    DEC enemyTempForLoop
    LDX #$00
    STX enemyDirectionIndex
    LDY #$02
    
    ; Loops so that we remove the stack pushes we did...variable length array
    ; X is the length of the array
    ; X is from the subAvailable[Direction] subroutine
    ; turning off the loop for now
    @loop:
    CPX enemyTempForLoop        ; this might be one short
    BCS commitMove

    ; finish working here
    ; it's sort working but not
    @continue:
    
    ; X doesn't go up by 1
    LDA enemyDistance + 1, X    ; high byte;        ; register
    CMP enemyDistance + 1, Y    ; high byte + 2     ; data 
    BCC @registerIsLower        ; branches if  data (Y) < register (X)
    BNE @registerIsHigher       ; branches if equal

    ; JMP @registerIsLower        ; happens if register (X) < data (Y)

    @checkLowerByte:
    LDA enemyDistance, X        ; low byte
    CMP enemyDistance, Y        ; low byte + 1
    BCC @registerIsLower
    BNE @registerIsHigher

    @registerIsLower:           ; happens if register (X) < data (Y)    
    JMP commitMove
    ; CPX enemyTempForLoop       ; this might be one short
    ; BEQ commitMove
    ; CPY #$04 ;enemyTempForLoop
    ; BEQ commitMove

    ; INY
    ; INY
    
    ; JMP @loop

    @registerIsHigher:          ; if  data (Y) < register (X)
    ; INX
    ; INX
    INC enemyDirectionIndex


    ; CPX enemyTempForLoop        ; this might be one short
    ; BEQ commitMove
    ; CPY #$04 ;enemyTempForLoop ; THIS IS PROBABLY WRONG
    ; BEQ commitMove


    ; INY
    ; INY

    ; JMP @loop
    
    ; X is 0 and Y is 1

    ; if enemyTempForLoop is 2
    ; X is 0 and Y is 2
    ; X is 1 and Y is 2

    

    ; CODE that evaluates the direction into the enemyX/Y buffer
    ; CODE that figures out the distance between two points
    ; CODE that compares the two values

    ; FOR NOW we are going to try a random 1 or 2
    ; use Y

commitMove:

    LDX enemyDirectionIndex

    LDA enemyDirectionArray, X          ; get the direction based on which index we picked

    CMP #$01
    BEQ @moveUp

    CMP #$02
    BEQ @moveDown

    CMP #$03
    BEQ @moveLeft

    CMP #$04
    BEQ @moveRight
    
    JMP @continueLoop                   ; if we have overflow? this catches bad bytes

    @moveUp:
    JSR enemyMoveUp
    LDA #$01
    STA enemyBufferDirectionCurrent

    JMP @continueLoop

    @moveDown:
    JSR enemyMoveDown
    LDA #$02
    STA enemyBufferDirectionCurrent

    JMP @continueLoop

    @moveLeft:
    JSR enemyMoveLeft
    LDA #$03
    STA enemyBufferDirectionCurrent
    JMP @continueLoop

    @moveRight:
    JSR enemyMoveRight
    LDA #$04
    STA enemyBufferDirectionCurrent
    JMP @continueLoop

    @continueLoop:
    INX

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
    
    JSR computeDistance1

    LDA #$01
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance1

    LDA #$03
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump
    LDA #$04
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
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance1

    LDA #$03
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump

    JSR computeDistance1

    LDA #$04
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
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkLeft

    JSR computeDistance1 ; not working might have to increment with X

    LDA #$02
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @dump

    JSR computeDistance1

    LDA #$03
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
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance1

    LDA #$02
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR newCheckBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @dump

    JSR computeDistance1

    LDA #$04
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

; these "work", but it's doing a signed instead of absolute value
absX:
    LDA enemyXBuffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA enemyGridX; reusing??? see if this works TODO, not neccessarily X

    CMP playerGridX
    BEQ @equal
    BCS @subtractSwap                    ; if enemyX is greater than playerLocationX

    @subtractNormal:
    SEC
    LDA playerGridX
    SBC enemyGridX
    JMP @dump

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridX
    JMP @dump

    @equal:
    LDA #$00

    @dump:
    STA enemyAbsX
    RTS

absY:
    LDA enemyYBuffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA enemyGridX ; reusing??? see if this works TODO, not neccessarily X

    CMP playerGridY
    BEQ @equal
    BCS @subtractSwap                 ; reverse since Y is different?

    @subtractNormal:
    SEC
    LDA playerGridY
    SBC enemyGridX
    JMP @dump

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridY

    @equal:
    LDA #$00

    @dump:
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

    CPX #$00
    BEQ @dump
    CPX #$01
    BEQ @dump
    
    DEX
    @additionLoop:
    CLC
    LDA sqOut               ; low byte
    ADC sqIn
    STA sqOut

    LDA sqOut + 1           ; high byte
    ADC #$00
    STA sqOut + 1

    DEX
    BNE @additionLoop

    @dump:
    PLA
    TAX

    RTS

;; figure out how to make this work
computeDistance1:

    TYA
    PHA

    TXA
    PHA

    LDY #$00
    @loopY:
    CPX #$00
    BEQ @runComp
    INY
    INY
    DEX
    JMP @loopY
    
    @runComp:
    PLA
    TAX

    JSR absX                                ; hopefully loop this
    LDA enemyAbsX
    STA sqIn                                ; change this? would need to be 16-bit
    JSR computeSquare

    CLC
    LDA sqOut
    STA enemyDistance, Y
    LDA sqOut + 1
    STA enemyDistance + 1, Y

    JSR absY
    STA sqIn                                ; change this? would need to be 16-bit
    JSR computeSquare

    CLC
    LDA sqOut
    ADC enemyDistance, Y
    STA enemyDistance, Y

    CLC
    LDA sqOut + 1
    ADC enemyDistance + 1, Y
    STA enemyDistance + 1, Y

    PLA
    TAY

    RTS