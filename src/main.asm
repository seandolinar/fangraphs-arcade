.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./player/playerDots.asm"
.include "./player/playerPosition.asm"
.include "./player/playerAnimation.asm"
.include "./enemy/enemy.asm"
.include "./enemy/enemyAI.asm"
.include "./enemy/enemyCollision.asm"
.include "./enemy/enemyPowerUp.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"
.include "./ppuUpdates.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"
.include "./tiles.asm";

.segment "TILES"
.incbin "../chr/char02.chr"

.segment "MUSIC"
.incbin "../nsf/export1.nsf", $80 ; offset of $80 so I don't have to trim this 


.segment "CODE"
NMI:
    ; this interrupts the main loop
   ; CHECK PAUSE
    ; Pause:
    ; LDA controllerBits
    ; AND #CONTROL_P1_START
    ; BNE @vBlankLoop
    
    ; RTI
    ; LDA gamePaused
    ; CMP #$01
    ; BNE @vBlankLoop

    ; RTI
  


; vBlankWait:	
@vBlankLoop:
	lda $2002   
    bpl @vBlankLoop

    JSR changeBackground
    JSR spriteTransfer
    ; JSR readController

    ; plays music, but this crashes horribly
    ; LDA #$00
    ; LDX #$00
    ; JSR $8060

    LDX masterTimer
    DEX
    STX masterTimer
   
@dumpNMI:
    RTI

; @resetTimer:
;     LDX #$08                ; controls the speed of the game
;     STX masterTimer
;     RTI

IRQ:
    RTI

; we are updating the position in MAIN
; but checking the position in NMI
Main:
    ; should check to see if controller Bits changed
    LDA controllerBits
    STA gamePaused ; temp
    JSR readController
    LDA controllerBits
    EOR gamePaused
    AND #CONTROL_P1_START
    BEQ @continue
    ; LDA #$09
    ; STA gamePaused

    ; PAUSE ROUTINE
    ; lda PPUCopy       ;load a ram coopy of $2000
    ; eor #%10000000    ;toggle nmi bit
    LDA #$00
    sta $2000 
    LDA #$05
    sta PPUCopy
    ; sta PPUCopy

    ; valid logic
    ; having issues if use the same button
    ; why won't this work?!
    @pauseLoop:
    LDA controllerBits
    STA gamePaused ; temp
    JSR readController
    LDA controllerBits
    EOR gamePaused ; difference in buttons
    AND controllerBits
    ; AND #CONTROL_P1_START  ; zeros out non-start bits
    AND #CONTROL_P1_DOWN ; zeros out non-down bits
    ; STA PPUCopy
    ; CMP #CONTROL_P1_START 
    BEQ @pauseLoop


    ; lda PPUCopy       ;load a ram coopy of $2000
    ; eor #%10000000    ;toggle nmi bit
    LDA #$00
    sta controllerBits
    LDA #%10000000 
    sta $2000 
    LDA #$07
    sta PPUCopy       ;load a ram coopy of $2000
    JMP Main

   


    @continue:
    LDY controlTimer
    CPY #$00
    BNE @exit
    JSR readController

    JSR updateDirection
    LDY #$30

    @exit:
    DEY
    STY controlTimer  

    LDX masterTimer
    CPX #$01
    BEQ @runMovement
    JMP Main                ; loops because of end

    @runMovement:

   

    LDX #$08                ; need to reset this
    STX masterTimer
    JSR nmiMovement
    JMP Main


nmiMovement:
    JSR incTimerPowerUp

    JSR dumpUpdatePosition      ; runs the player updates ;change this to update direction
    ; this should handle when to move the sprites
    JSR checkCollisionSprites ; this isn't working

    JSR setAnimationPlayerMain
    JSR setAnimationPlayerDirection
    JSR checkCollisionSprites ; this isn't working
    JSR checkCollisionPowerUp
    JSR nextEnemyMovement   ; move this to main?
    JSR checkCollisionSprites ; this isn't working

    INC enemyMode

    JSR checkWin          ; maybe this sits well here?

@dump:
    RTS

