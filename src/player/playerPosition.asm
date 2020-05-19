.segment "CODE"
; this will have to change to read controller
; rename this it's just reading the controller now
updateDirection:

  LDA playerLocationX ; i changed these from the buffer, it should be the original, but in case something breaks
  STA collisionTestX

  LDA playerLocationY
  STA collisionTestY

  LDA controllerBits
  AND #CONTROL_P1_UP ;UP
  BEQ dumpControlUp ; dumps if we have no A push
  JSR setUp
dumpControlUp:
  LDA controllerBits
  AND #CONTROL_P1_DOWN ;DOWN
  BEQ dumpControlDown ; dumps if we have no UP push
  JSR setDown
dumpControlDown:
  LDA controllerBits
  AND #CONTROL_P1_LEFT ;LEFT
  BEQ dumpControlLeft ; dumps if we have no DOWN push
  JSR setLeft
dumpControlLeft:
  LDA controllerBits
  AND #CONTROL_P1_RIGHT ;RIGHT
  BEQ dumpUpdateController ; dumps if we have no LEFT push
  JSR setRight

dumpUpdateController:
  RTS
  
; i can make this separate from the the controller 
; this will basically become the update position
; rename this
dumpUpdatePosition:

    LDA playerDirectionCurrent
    CMP #$01
    BNE dumpDirectionUp
    JSR moveUp
    JMP updatePositionSprite

dumpDirectionUp:
    LDA playerDirectionCurrent
    CMP #$02
    BNE dumpDirectionDown
    JSR moveDown
    JMP updatePositionSprite
    
dumpDirectionDown:
    LDA playerDirectionCurrent
    CMP #$03
    BNE dumpDirectionLeft
    JSR moveLeft
    JMP updatePositionSprite

dumpDirectionLeft:
    LDA playerDirectionCurrent
    CMP #$04
    BNE dumpDirectionRight
    JSR moveRight
    JMP updatePositionSprite

dumpDirectionRight:

updatePositionSprite:
    LDA playerLocationX
    SEC
    SBC #$04
    STA player_oam + 3 ; place in RAM where the sprite Y is controlled
    STA player_oam + 7 ; place in RAM where the sprite Y is controlled


    CLC
    ADC #$08           ; check on the number
    STA player_oam + 11 ; place in RAM where the sprite Y is controlled
    STA player_oam + 15 ; place in RAM where the sprite Y is controlled

    LDA playerLocationX
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridX 

    LDA playerLocationY
    SEC
    SBC #$04
    STA player_oam ; place in RAM where the sprite X is controlled
    STA player_oam + 8 ; place in RAM where the sprite X is controlled

    CLC
    ADC #$08
    STA player_oam + 4
    STA player_oam + 12

    LDA playerLocationY
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridY

    ; took this out
    ; not sure if this is neccessary
    ; LDA #00
    ; STA controllerBits
    RTS

setUp:

    LDA playerLocationY
    SEC
    SBC #$08   
    STA collisionTestY  

    ; I shouldn't need this, but yet I do
    ; somewhere the collisionTestY gets clobbered after setting it earlier.
    LDA playerLocationX
    STA collisionTestX
    
    JSR checkCollision
    LDA collisionFlag
    BEQ @exit ; branch if 0

    LDA #$01 ; UP
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationY ;; shouldn't have to have this here
    STA collisionTestY 
    
    RTS
   
setDown:

    LDA playerLocationY
    CLC
    ADC #$08   
    STA collisionTestY  

    ; I shouldn't need this, but yet I do
    ; somewhere the collisionTestY gets clobbered after setting it earlier.
    LDA playerLocationX
    STA collisionTestX
    
    JSR checkCollision
    LDA collisionFlag
    BEQ @exit ; branch if 0

    LDA #$02 ; DOWN
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationY ;; shouldn't have to have this here
    STA collisionTestY 
    
    RTS

setLeft:

    LDA playerLocationX
    SEC
    SBC #$08   
    STA collisionTestX  

    ; I shouldn't need this, but yet I do
    ; somewhere the collisionTestY gets clobbered after setting it earlier.
    LDA playerLocationY
    STA collisionTestY  


    JSR checkCollision
    LDA collisionFlag
    BEQ @exit ; branch if 0

    LDA #$03 ; LEFT
    STA playerDirectionCurrent
    @exit:
    LDA playerLocationX ;; shouldn't have to have this here
    STA collisionTestX  
    RTS

setRight:

    LDA playerLocationX
    CLC
    ADC #$08   
    STA collisionTestX  

    ; I shouldn't need this, but yet I do
    ; somewhere the collisionTestY gets clobbered after setting it earlier.
    LDA playerLocationY
    STA collisionTestY  

    JSR checkCollision ; i could be clobbering something by repeatly calling this while holding down a button
    LDA collisionFlag

    BEQ @exit ; branch if 0

    LDA #$04 ; RIGHT
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationX ;; shouldn't have to have this here
    STA collisionTestX  
    RTS

moveRight:
        LDX #$00
        LDA playerLocationX
        CMP #$ff                ;; CHECK COLLISION
        BCS dumpMoveRight
        CLC
        ADC #$08
        STA playerLocationXBuffer
        STA collisionTestX      ; only need the added value for rigth

        LDA playerLocationY
        STA collisionTestY     ; ugh, see if we need this


        JSR checkCollision
        JSR checkCollideDot     ; calling this here. there might be a better way to do this.

        LDA collisionFlag
        BEQ dumpMoveRight ; branch if 0
        
        LDA playerLocationXBuffer
        STA playerLocationX

        JMP updatePositionSprite

dumpMoveRight:
        LDA playerLocationX
        STA playerLocationXBuffer
        STA collisionTestX
        JMP updatePositionSprite


moveLeft:
        LDX #$00
        LDA #$00                ;; CHECK COLLISION
        CMP playerLocationX
        BCS dumpMoveLeft
        LDA playerLocationX
        SEC
        SBC #$08
        STA playerLocationXBuffer
        STA collisionTestX

        LDA playerLocationY
        STA collisionTestY     ; ugh, see if we need this

        JSR checkCollision
        JSR checkCollideDot

        LDA collisionFlag
        BEQ dumpMoveLeft ; branch if 0

        LDA playerLocationXBuffer
        STA playerLocationX

        JMP updatePositionSprite

dumpMoveLeft:
        LDA playerLocationX
        STA playerLocationXBuffer
        STA collisionTestX
        JMP updatePositionSprite



moveUp:
        LDX #$00
        LDA #$00                ;; CHECK COLLISION
        CMP playerLocationY
        BCS dumpMoveUp

        LDA playerLocationY
        SEC
        SBC #$08
        STA playerLocationYBuffer
        STA collisionTestY

        JSR checkCollision
        JSR checkCollideDot

        LDA collisionFlag
        BEQ dumpMoveUp ; branch if 0

        LDA playerLocationYBuffer
        STA playerLocationY
        
        JMP updatePositionSprite

dumpMoveUp:
        LDA playerLocationY
        STA playerLocationYBuffer
        JMP updatePositionSprite

moveDown:
        LDX #$00
        LDA playerLocationY               ;; CHECK COLLISION
        CMP #$d0
        BCS dumpMoveDown

        LDA playerLocationY
        CLC
        ADC #$08
        STA playerLocationYBuffer

        STA collisionTestY

        JSR checkCollision
        JSR checkCollideDot


        LDA collisionFlag
        BEQ dumpMoveDown ; branch if 0
        
        LDA playerLocationYBuffer
        STA playerLocationY
        JMP updatePositionSprite

dumpMoveDown:
        LDA playerLocationY
        STA playerLocationYBuffer
        JMP updatePositionSprite

checkCollision:
    ; set the collision flag to 0 -- or false
    LDA #$01         ; 0 means there is a collision
    STA collisionFlag
    LDX #$00

checkBackgroundCollisionLoop:

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

    ; take this to ram
    ; encoding might help here
    ; fills out pointer for 
    LDA #<nametable_buffer
    STA collisionPointerLo
    LDA #>nametable_buffer
    STA collisionPointerHi

    ; calculates grid position for X (should only be 8-bit)
    CLC
    LDA collisionTestX ; playerPosition in the buffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridX ; converts to grid

    ; stores 0 into pointer
    LDA #$00
    STA playerPointerLo
    STA playerPointerHi

m1:
    ;calculates the grid position for Y (16-bit)
    ;mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across 

    ; short cutting this because I shouldn't have a carry
    CLC
    LDA playerPointerHi 
    ASL                    ; needed to multiply the high byte
    STA playerPointerHi

    CLC
    LDA collisionTestY ; 8 pixels ; player Y in buffer
    ASL ; Fist x2
    STA playerPointerLo ; saves the low byte
    LDA #$00
    ADC playerPointerHi
    STA playerPointerHi
    
    ; BCC m2 ; branch on carry clear
    ; INC playerPointerHi

m2:
    LDA playerPointerHi 
    ASL                    ; needed to multiply the high byte
    STA playerPointerHi

    LDA playerPointerLo
    ASL ; Second x2
    STA playerPointerLo
    LDA #$00
    ADC playerPointerHi
    STA playerPointerHi
    ; BCC dumpFirstMult ; branch on carry clear
    ; INC playerPointerHi

; what does this mean?
dumpFirstMult:
    
    LDA playerPointerLo
    CLC
    ADC playerGridX
    STA playerPointerLo
    BCC dumpSecondMult   
    INC playerPointerHi

dumpSecondMult:
    
    LDA playerPointerLo ; loads the low byte of where the player is
    CLC 
    ADC collisionPointerLo ; adds to the collision pointer?
    STA backgroundPointerLo ; saves into the background pointer
    LDA playerPointerHi ; loads the player high byte
    ADC collisionPointerHi ; adds to high
    STA backgroundPointerHi ; saves to high

    LDY #$00 ; resets Y
    LDA (backgroundPointerLo), Y ; probably don't need to index this, but I do, why?
    ; I do, this is indirect, I think I have to do it this way
    STA collisionBackgroundTile

    ; this is causing some issues i should spin this out so the subroutine can be used more
    CMP #$03
    BEQ @collideDotBranch
    CMP #$04
    BEQ @collideDotBranch
    

    LDX #$00
    @loopBases:
    CMP tilesBases, X
    BEQ @dump
    CPX #$0a
    BEQ @continueToBlank
    INX
    JMP @loopBases

    @continueToBlank:
    CMP #$02 ;; whatever are loading it's all 0s
    BNE collide

    JMP @dump

    @collideDotBranch:
    ; JSR collideDot

    @dump:
    RTS


allowPass:

    INX
    INX
    INX
    INX
    ; why am I incrementing here

    ; CPX #$18
    ; BMI checkCollisionLoop

    LDA #$01
    STA collisionFlag
    RTS


collide:
    LDA #$00
    STA collisionFlag

dumpCollide:
    RTS
