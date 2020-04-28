.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./playerDots.asm"
.include "./playerPosition.asm"
.include "./enemy.asm"
.include "./enemyAI.asm"
.include "./enemyCollision.asm"
.include "./enemyPowerUp.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
.incbin "../chr/char02.chr"


.segment "CODE"
NMI:
    ; this interrupts the main loop

; vBlankWait:	
@vBlankLoop:
	lda $2002   
    bpl @vBlankLoop

    JSR changeBackground
    JSR spriteTransfer
    

dumpNMI:
    RTI

IRQ:
    RTI

Main:
    JSR checkCollisionPowerUp
    JSR checkCollisionSprites


; ???

MainReadController:
    LDA controllerBits
    BEQ Main                ; go loop main if we have no controller bits
    JSR updatePosition      ; runs the player updates
    JMP Main                ; loops because of end




; ; put this in a PPU file

changeBackground:
; background
; I don't have to turn this off
; I'm not sure why
    LDA #$00
	STA $2000               ; disable NMI
	STA $2001               ; disable rendering

    ; LDA $2002               ; read PPU status to reset the high/low latch to high
    ; LDA #$3F
    ; STA $2006               ; write the high byte of $3F10 address
    ; LDA #$10
    ; STA $2006               ; write the low byte of $3F10 address

    ; LDX #$00                ; start out at 0
    ; LDA bufferBackgroundColor
    ; STA $2007

    ; this is for eating the dot
    ; should rewrite this
    LDA $2002               ; read PPU status to reset the high/low latch to high
    LDA bufferBackgroundValHi
    STA $2006               ; write the high byte of $3F10 address
    LDA bufferBackgroundValLo
    STA $2006               ; write the low byte of $3F10 address

    ; this is causing issues with the background though!
    LDA #$02
    STA $2007

    ; resets scroll
    ; not sure why I have to do this, but it works!!
    LDA #$00
    STA PPU_SCROLL_REG 
    STA PPU_SCROLL_REG
    ; STA PPU_CTRL_REG1


    ; ; STARTS VIDEO DISPLAY
    LDA #%10000000          ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000

    LDA #%00011110          ; enable sprites, enable background, no clipping on left side
    STA $2001
    RTS


spriteTransfer:       
    ; SPRITE TRANSFER
    ; does this every frame
    LDA #$00
    STA $2003               ; set the low byte (00) of the RAM address
    LDA #>player_oam        ; this works and so does $02
    STA $4014               ; set the high byte (02) of the RAM address, start the transfer

    JSR readController
    JSR incTimerPowerUp

    LDX masterTimer
    DEX
    STX masterTimer
    BNE @dump
    JSR dumpUpdatePosition
    JSR countDots
    JSR nextEnemyMovement   ; move this to main?
    LDX #$08                ; controls the speed of the game
    STX masterTimer
@dump:
    RTS