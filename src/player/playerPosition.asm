.segment "CODE"
; this will have to change to read controller
updateDirection:

  LDA playerLocationX
  STA collisionTestX

  LDA playerLocationY
  STA collisionTestY

  LDA controllerBits
  AND #CONTROL_P1_UP
  BEQ dumpControlUp 
  JSR setUp
dumpControlUp:
  LDA controllerBits
  AND #CONTROL_P1_DOWN 
  BEQ dumpControlDown
  JSR setDown
dumpControlDown:
  LDA controllerBits
  AND #CONTROL_P1_LEFT
  BEQ dumpControlLeft 
  JSR setLeft
dumpControlLeft:
  LDA controllerBits
  AND #CONTROL_P1_RIGHT 
  BEQ dumpUpdateController
  JSR setRight

dumpUpdateController:
  RTS
  
UpdatePositionPlayer:

    LDA playerDirectionCurrent
    CMP #DIRECTION_UP
    BNE dumpDirectionUp
    JSR moveUp
    JMP updatePositionSprite

dumpDirectionUp:
    LDA playerDirectionCurrent
    CMP #DIRECTION_DOWN
    BNE dumpDirectionDown
    JSR moveDown
    JMP updatePositionSprite
    
dumpDirectionDown:
    LDA playerDirectionCurrent
    CMP #DIRECTION_LEFT
    BNE dumpDirectionLeft
    JSR moveLeft
    JMP updatePositionSprite

dumpDirectionLeft:
    LDA playerDirectionCurrent
    CMP #DIRECTION_RIGHT
    BNE dumpDirectionRight
    JSR moveRight
    JMP updatePositionSprite

dumpDirectionRight:

updatePositionSprite:
    LDA playerLocationX
    SEC
    SBC #$04
    STA player_oam + 3  ; place in RAM where the sprite Y is controlled
    STA player_oam + 7  ; place in RAM where the sprite Y is controlled


    CLC
    ADC #$08            ; check on the number
    STA player_oam + 11 ; place in RAM where the sprite Y is controlled
    STA player_oam + 15 ; place in RAM where the sprite Y is controlled

    LDA playerLocationX
    LSR                 ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridX 

    LDA playerLocationY
    SEC
    SBC #$04
    STA player_oam      ; place in RAM where the sprite X is controlled
    STA player_oam + 8  ; place in RAM where the sprite X is controlled

    CLC
    ADC #$08
    STA player_oam + 4
    STA player_oam + 12

    LDA playerLocationY
    LSR                 ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA playerGridY

    RTS

setUp:

    LDA playerLocationY
    SEC
    SBC #$08   
    STA collisionTestY  

    LDA playerLocationX
    STA collisionTestX
    
    JSR checkCollision
    LDA collisionFlag
    BEQ @exit 

    LDA #DIRECTION_UP
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationY 
    STA collisionTestY 
    
    RTS
   
setDown:

    LDA playerLocationY
    CLC
    ADC #$08   
    STA collisionTestY  

    LDA playerLocationX
    STA collisionTestX
    
    JSR checkCollision
    LDA collisionFlag
    BEQ @exit 

    LDA #DIRECTION_DOWN 
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationY 
    STA collisionTestY 
    
    RTS

setLeft:

    LDA playerLocationX
    SEC
    SBC #$08   
    STA collisionTestX  

    LDA playerLocationY
    STA collisionTestY  


    JSR checkCollision
    LDA collisionFlag
    BEQ @exit 

    LDA #DIRECTION_LEFT 
    STA playerDirectionCurrent
    @exit:
    LDA playerLocationX 
    STA collisionTestX  
    RTS

setRight:

    LDA playerLocationX
    CLC
    ADC #$08   
    STA collisionTestX  

    LDA playerLocationY
    STA collisionTestY  

    JSR checkCollision 
    LDA collisionFlag

    BEQ @exit 

    LDA #DIRECTION_RIGHT 
    STA playerDirectionCurrent

    @exit:
    LDA playerLocationX 
    STA collisionTestX  
    RTS

moveRight:
        LDX #$00
        LDA playerLocationX
        CMP #$ff                
        BCS dumpMoveRight
        CLC
        ADC #$08
        STA playerLocationXBuffer
        STA collisionTestX      

        LDA playerLocationY
        STA collisionTestY     


        JSR checkCollision
        JSR checkCollideDot     


        LDA collisionFlag
        BEQ dumpMoveRight 
        
        LDA playerLocationXBuffer
        STA playerLocationX

        JSR incrementAnimationTimer

        JMP updatePositionSprite

dumpMoveRight:
        LDA playerLocationX
        STA playerLocationXBuffer
        STA collisionTestX
        JMP updatePositionSprite


moveLeft:
        LDX #$00
        LDA #$00             
        CMP playerLocationX
        BCS dumpMoveLeft
        LDA playerLocationX
        SEC
        SBC #$08
        STA playerLocationXBuffer
        STA collisionTestX

        LDA playerLocationY
        STA collisionTestY    

        JSR checkCollision
        JSR checkCollideDot

        LDA collisionFlag
        BEQ dumpMoveLeft 

        LDA playerLocationXBuffer
        STA playerLocationX

        JSR incrementAnimationTimer

        JMP updatePositionSprite

dumpMoveLeft:
        LDA playerLocationX
        STA playerLocationXBuffer
        STA collisionTestX
        JMP updatePositionSprite

moveUp:
        LDX #$00
        LDA #$00                
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
        BEQ dumpMoveUp 

        LDA playerLocationYBuffer
        STA playerLocationY
        
        JSR incrementAnimationTimer

        JMP updatePositionSprite

dumpMoveUp:
        LDA playerLocationY
        STA playerLocationYBuffer
        JMP updatePositionSprite

moveDown:
        LDX #$00
        LDA playerLocationY      
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
        BEQ dumpMoveDown 
        
        LDA playerLocationYBuffer
        STA playerLocationY

        JSR incrementAnimationTimer

        JMP updatePositionSprite

dumpMoveDown:
        LDA playerLocationY
        STA playerLocationYBuffer
        JMP updatePositionSprite
