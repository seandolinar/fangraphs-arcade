
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


enemyAIMovementSetup:
    LDA enemyX, X
    STA enemyXBuffer            ; buffer is always temp within subroutines
    STA enemyXWork              ; work will not change, essentially a paramter of pickDirection

    LDA enemyY, X
    STA enemyYBuffer
    STA enemyYWork

    LDA enemy1DirectionCurrent, X
    STA enemyBufferDirectionCurrent

    ; creates the AI position
    ; different for each enemy
    LDA playerGridX
    STA playerGridXAI

    LDA playerGridY
    STA playerGridYAI

    LDA enemyMode
    CMP #$D0
    BCC modeAttack

    JMP modeAlt

    modeAttack:
    CPX #$03
    BEQ aiUmp4

    CPX #$02
    BEQ aiUmp3

    CPX #$01
    BEQ aiUmp2
   
    aiUmp1:
        ; do nothing
        JMP mainAI

    aiUmp2:
        ; targets two tiles below player
        CLC
        LDA playerGridY
        ADC #$02
        STA playerGridYAI
        JMP mainAI

    aiUmp3:
        ; we have this enemy lead the player by two tiles

        LDA playerDirectionCurrent
        CMP #$01
        BEQ @playerUp
        CMP #$02
        BEQ @playerDown
        CMP #$03
        BEQ @playerLeft

        ; player going right
        @playerRight:
        CLC
        LDA playerGridX
        ADC #$04
        STA playerGridXAI
        JMP mainAI


        ; player going up
        @playerUp:
        SEC
        LDA playerGridY
        SBC #$04
        STA playerGridYAI
        JMP mainAI


        ; player going down
        @playerDown:
        CLC
        LDA playerGridY
        ADC #$04
        STA playerGridYAI
        JMP mainAI

        ; player going left
        @playerLeft:
        SEC
        LDA playerGridX
        SBC #$04
        STA playerGridXAI
        JMP mainAI

    aiUmp4:
        ; make the fourth ump target 1 tiles to the right
        LDA playerGridX
        ADC #$02
        STA playerGridXAI
        JMP mainAI

    modeAlt:
    CPX #$03
    BEQ aiUmp4Alt

    CPX #$02
    BEQ aiUmp3Alt

    CPX #$01
    BEQ aiUmp2Alt
   
    ; refactor this because it could loop
    aiUmp1Alt:
        ; LDA powerUpX       
        LDA #$08
        STA playerGridXAI

        ; LDA powerUpY       
        LDA #$02
        STA playerGridYAI
        JMP mainAI

    aiUmp2Alt:
        ; LDA powerUpX + 1    
        LDA #$20  
        STA playerGridXAI

        ; LDA powerUpY + 1  
        LDA #$10
        STA playerGridYAI

        JMP mainAI

    aiUmp3Alt:
        ; LDA powerUpX + 2       
        LDA #$00
        STA playerGridXAI

        ; LDA powerUpY + 2     
        LDA #$10
        STA playerGridYAI

        JMP mainAI

    aiUmp4Alt:
        ; LDA powerUpX + 3  
        LDA #$10
        STA playerGridXAI

        ; LDA powerUpY + 3
        LDA #$20
        STA playerGridYAI
        JMP mainAI




runEnemyAI:
    
    TYA                                 ; use Y for the randomizer
    PHA
    TXA
    PHA

    ;;clear for debug;;
    LDA #$00
    STA enemyDirectionArray
    STA enemyDirectionArray + 1
    STA enemyDirectionArray + 2

    STA enemyDistance
    STA enemyDistance + 1
    STA enemyDistance + 2
    STA enemyDistance + 3
    STA enemyDistance + 4
    STA enemyDistance + 5

    
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks the three directions;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
subAvailableUp:
    ; I'm not resetting X going into here.
    ; We need X coming out of here
    LDX #$00

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

    JSR computeDistance

    LDA #DIRECTION_RIGHT
    STA enemyDirectionArray, X
    INX

    @break:
    DEX
    STX enemyDirectionIndex
    RTS

subAvailableDown:
    LDX #$00

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
    DEX
    STX enemyDirectionIndex
    RTS

subAvailableLeft: 
    LDX #$00

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
    DEX
    STX enemyDirectionIndex
    RTS

subAvailableRight:
    LDX #$00

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
    DEX
    STX enemyDirectionIndex
    RTS



jmpCommitMove:
    JMP commitMove ; change to second phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chooses the direction based on the direction ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; this is close to being a loop
;; not working yet
chooseFromAvailableDirections:

    ; resetting buffer
    LDA enemyXWork
    STA enemyXBuffer
    LDA enemyYWork
    STA enemyYBuffer

    ; going to have to rework this
    LDX enemyDirectionIndex
    STX enemyTempForLoop ; move this?

    LDA #$00
    STA enemyDirectionIndex
    
    LDX #$00
    LDY #$02

    LDA #$01
    STA enemyAIIndex
    
    ; Loops so that we remove the stack pushes we did...variable length array
    ; X is the length of the array
    ; X is from the subAvailable[Direction] subroutine
    ; turning off the loop for now
    ; DEC enemyTempForLoop
   

    ; start loop here
    loopCompareDistance:
    ; if we only have one direction, commit the move
    LDA enemyTempForLoop        ; this might be one short
    CMP #$00
    BEQ jmpCommitMove

    @checkHiByte:
    LDA enemyDistance + 1, X    ; high byte;        ; register
    CMP enemyDistance + 1, Y    ; high byte + 2     ; data 
    BCC @registerIsLower        ; branches if  data (Y) < register (X)
    BNE @registerIsHigher       ; branches if equal

                                ; happens if register (X) < data (Y)
    @checkLowByte:
    LDA enemyDistance, X        ; low byte
    CMP enemyDistance, Y        ; low byte + 1
    BCC @registerIsLower
    BNE @registerIsHigher

    @registerIsLower:               ; happens if register (X) < data (Y)  
    ; LDA enemyDistance, X 
    LDA gameStateIsPowered          ; swap if we are powered up
    CMP #$00
    BNE @registerIsLowerPowerUp

    JMP readyLoop    ; change to second phase

    @registerIsLowerPowerUp:  
    ; POWER UP
    LDA frameTimer
    AND #$01
    BNE @randomLower

    LDA enemyAIIndex
    STA enemyDirectionIndex

    @randomLower:

    TYA
    TAX
    
    JMP readyLoop    ; change to second phase

    @registerIsHigher:              ; if  data (Y) < register (X)
    LDA gameStateIsPowered          ; swap if we are powered up
    CMP #$00
    BNE @registerIsHigherPowerUp
        
    LDA enemyAIIndex
    STA enemyDirectionIndex

    TYA
    TAX
    
    @registerIsHigherPowerUp:
    ; POWER UP
    LDA frameTimer
    AND #$01
    BNE readyLoop
    LDA enemyAIIndex
    STA enemyDirectionIndex
    
    readyLoop:
    CPY #$04
    BEQ commitMove

    INY
    INY

    INC enemyAIIndex
    
    DEC enemyTempForLoop

    JMP loopCompareDistance

commitMove:

    LDX enemyDirectionIndex
    ; DEX

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
    DEX ; don't know if this does anything

    @dumpLoop:
    PLA                 ; put X/Y back
    TAX

    PLA
    TAY

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Changes the enemy buffer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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


