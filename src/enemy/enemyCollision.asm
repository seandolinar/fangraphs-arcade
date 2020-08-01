newCheckBackgroundCollisionEnemy:
    ; this was working before beause we never set the collionsFlagEnemy
    ; now it's outputting 4
    ; which prevents it from moving

    LDA #$00
    STA collisionFlagEnemy

    ; can I blow away X?
    LDA inning
    AND #$03

    CMP #$01
    BEQ @board1
    CMP #$02
    BEQ @board2
    CMP #$03
    BEQ @board3

    LDA #<game_board0
    STA collisionPointerLoEnemy
    LDA #>game_board0
    STA collisionPointerHiEnemy

    JMP @continue

    @board1:

    LDA #<game_board1
    STA collisionPointerLoEnemy
    LDA #>game_board1
    STA collisionPointerHiEnemy

    JMP @continue

    @board2:

    LDA #<game_board2
    STA collisionPointerLoEnemy
    LDA #>game_board2
    STA collisionPointerHiEnemy

    JMP @continue

    @board3:

    LDA #<game_board3
    STA collisionPointerLoEnemy
    LDA #>game_board3
    STA collisionPointerHiEnemy

    @continue:
    CLC
    LDA enemyXBuffer
    LSR                         ; divide / 2 / 2 / 2
    LSR
    LSR
    STA enemyGridX              ; finds spot on grid

    ; stores 0 into pointer
    LDA #$00
    STA enemyPointerLo
    STA enemyPointerHi

me1:

    ; short cutting this because I shouldn't have a carry
    ; mult x 2 x 2 ;; divide by 8 pixels then multiply by 32 items across 
    CLC
    LDA enemyPointerHi 
    ASL                    ; needed to multiply the high byte
    STA enemyPointerHi

    CLC
    LDA enemyYBuffer       ; 8 pixels ; player Y in buffer
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
    ASL                    ; Second x2
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

    ; refactor for stack
    STY tempY
    STX tempX

    LDY #$00 ; resets Y
    LDA (backgroundPointerLo), Y ; i'm getting 1 here
    ; I do, this is indirect, I think I have to do it this way
    LDY tempY 
  
    ; I'm looping through some duplicate dots here
    ; because I'm combining dots + powerups,
    ; which have power up + dot tiles
    LDX #$00
    @loopBases2:
    CMP tilesDots, X
    BEQ dumpCollideEnemy
    CPX #$10
    BEQ collideEnemy
    INX
    JMP @loopBases2
    ; might have to do something to increase to compare tilesDots


collideEnemy:
    LDA #$01
    STA collisionFlagEnemy
    LDX tempX
    RTS
dumpCollideEnemy:
    LDA #$0e
    LDX tempX
    RTS