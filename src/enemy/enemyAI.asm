
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

runEnemyAI:

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

                                ; happens if register (X) < data (Y)
    @checkLowerByte:
    LDA enemyDistance, X        ; low byte
    CMP enemyDistance, Y        ; low byte + 1
    BCC @registerIsLower
    BNE @registerIsHigher

    @registerIsLower:           ; happens if register (X) < data (Y)  
    LDA gameStateIsPowered      ; swap if we are powered up
    CMP #$00
    BNE @registerIsLowerPowerUp

    JMP commitMove              ; commits the move on the current index

    @registerIsLowerPowerUp:  
    INC enemyDirectionIndex
    JMP commitMove              ; commits the move on the second index

   
    @registerIsHigher:          ; if  data (Y) < register (X)
    LDA gameStateIsPowered      ; swap if we are powered up
    CMP #$00
    BNE @registerIsHigherPowerUp
    INC enemyDirectionIndex      ; commits the move on the second index
    JMP commitMove              ; commits the move on the second index

    @registerIsHigherPowerUp:
    JMP commitMove



    ; THERE IS NO LOOP because I'm just comparing two items

    ; CODE that evaluates the direction into the enemyX/Y buffer
    ; CODE that figures out the distance between two points
    ; CODE that compares the two values

    ; FOR NOW we are going to try a random 1 or 2
    ; use Y

commitMove:

    LDX enemyDirectionIndex

    LDA enemyDirectionArray, X          ; get the direction based on which index we picked

    CMP #DIRECTION_UP
    BEQ @moveUp

    CMP #DIRECTION_DOWN
    BEQ @moveDown

    CMP #DIRECTION_LEFT
    BEQ @moveLeft

    CMP #DIRECTION_RIGHT
    BEQ @moveRight
    
    JMP @continueLoop                   ; if we have overflow? this catches bad bytes

    @moveUp:
    JSR enemyMoveUp
    LDA #DIRECTION_UP
    STA enemyBufferDirectionCurrent

    JMP @continueLoop

    @moveDown:
    JSR enemyMoveDown
    LDA #DIRECTION_DOWN
    STA enemyBufferDirectionCurrent

    JMP @continueLoop

    @moveLeft:
    JSR enemyMoveLeft
    LDA #DIRECTION_LEFT
    STA enemyBufferDirectionCurrent
    JMP @continueLoop

    @moveRight:
    JSR enemyMoveRight
    LDA #DIRECTION_RIGHT
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
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkLeft
    
    JSR computeDistance

    LDA #DIRECTION_UP
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance

    LDA #DIRECTION_LEFT
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @break
    LDA #DIRECTION_RIGHT
    STA enemyDirectionArray, X
    INX

    @break:
    RTS

subAvailableDown:
    @checkDown:
    JSR enemyMoveDown
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkLeft

    JSR computeDistance

    LDA #DIRECTION_DOWN
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance

    LDA #DIRECTION_LEFT
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @break

    JSR computeDistance

    LDA #DIRECTION_RIGHT
    STA enemyDirectionArray, X
    INX

    @break:
    RTS

subAvailableLeft: 
    @checkUp:
    JSR enemyMoveUp
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkDown

    JSR computeDistance

    LDA #DIRECTION_UP
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkLeft

    JSR computeDistance ; not working might have to increment with X

    LDA #DIRECTION_DOWN
    STA enemyDirectionArray, X
    INX

    @checkLeft:
    JSR enemyMoveLeft
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @break

    JSR computeDistance

    LDA #DIRECTION_LEFT
    STA enemyDirectionArray, X
    INX

    @break:
    RTS

subAvailableRight:
    @checkUp:
    JSR enemyMoveUp
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will not move
    BNE @checkDown

    JSR computeDistance

    LDA #DIRECTION_UP
    STA enemyDirectionArray, X
    INX

    @checkDown:
    JSR enemyMoveDown
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @checkRight

    JSR computeDistance

    LDA #DIRECTION_DOWN
    STA enemyDirectionArray, X
    INX

    @checkRight:
    JSR enemyMoveRight
    JSR checkBackgroundCollisionEnemy
    LDA collisionFlagEnemy ; 0 will allow a pass, 1 will no move
    BNE @break

    JSR computeDistance

    LDA #DIRECTION_RIGHT
    STA enemyDirectionArray, X
    INX

    @break:
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

    CMP playerGridXAI
    BEQ @equal
    BCS @subtractSwap                    ; if enemyX is greater than playerLocationX

    @subtractNormal:
    SEC
    LDA playerGridXAI
    SBC enemyGridX
    JMP @break

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridXAI
    JMP @break

    @equal:
    LDA #$00

    @break:
    STA enemyAbsX
    RTS

absY:
    LDA enemyYBuffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA enemyGridX ; reusing??? see if this works TODO, not neccessarily X

    CMP playerGridYAI
    BEQ @equal
    BCS @subtractSwap                 ; reverse since Y is different?

    @subtractNormal:
    SEC
    LDA playerGridYAI
    SBC enemyGridX
    JMP @dump

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridYAI

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
computeDistance:

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
