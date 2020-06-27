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
    ; this checks for the dots, but the dots never change
    ; this could cause other issues, plus I have to add in the extra blank tile
    CMP #$03
    BEQ @collideDotBranch
    CMP #$04
    BEQ @collideDotBranch
    CMP #$34
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

    LDA #$01
    STA collisionFlag
    RTS


collide:
    LDA #$00
    STA collisionFlag

dumpCollide:
    RTS
