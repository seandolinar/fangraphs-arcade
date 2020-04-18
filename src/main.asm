.include "./header.asm"
.include "./res.asm"
.include "./controller.asm"
.include "./position.asm"
.include "./enemy.asm"
.include "./checkCollisonPowerUp.asm"
.include "./checkCollisonSprites.asm"
.include "./sound.asm"

.include "./reset.asm"
.include "./pallete.asm"
.include "./init_load.asm"

.segment "TILES"
;.incbin "../chr/mario.chr"
.incbin "../chr/char01.chr"


.segment "CODE"
NMI:
    ; this interrupts the main loop

vwait:	
	lda $2002    ;wait
	bpl vwait


    
    LDA #$00
	; STA $2000 ; disable NMI
	STA $2001 ; disable rendering

    lda #$3f
    sta $2006
    lda #$00
    sta $2006

    LDA $2002    ; read PPU status to reset the high/low latch to high
    LDA #$3F
    STA $2006    ; write the high byte of $3F10 address
    LDA #$00
    STA $2006    ; write the low byte of $3F10 address


    LDX #$00                ; start out at 0
    LDA #$06
    STA $2007
    ; LoadPalettesLoopNew:
    ; LDA pallete, X      ; load data from address (PaletteData + the value in x)
    ;                         ; 1st time through loop it will load PaletteData+0
    ;                         ; 2nd time through loop it will load PaletteData+1
    ;                         ; 3rd time through loop it will load PaletteData+2
    ;                         ; etc
    ; STA $2007               ; write to PPU
    ; INX                     ; X = X + 1
    ; CPX #$20               ; Compare X to hex $20, decimal 32
    ; BNE LoadPalettesLoopNew 

     ; STARTS VIDEO DISPLAY
    LDA #%10000000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000

    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA $2001



          
    ; SPRITE TRANSFER
    ; does this every frame
    LDA #$00
    STA $2003  ; set the low byte (00) of the RAM address
    LDA #>player_oam ; this works and so does $02
    STA $4014  ; set the high byte (02) of the RAM address, start the transfer

    JSR readController
    JSR incTimerPowerUp

    LDX masterTimer
    DEX
    STX masterTimer
    BNE dumpNMI
    JSR nextEnemyMovement
    LDX #$10
    STX masterTimer

    ; LDA #$00
    ; STA $2001  ;Disable rendering

    ; LDA $2002  
    ; LDA #$3F
    ; STA $2006
    ; LDA #$00
    ; STA $2006
    
    ; LDA #$16
    ; STA $2007  ;Change Main Background color
    

    ; LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    ; STA $2001
	; lda #$01        ; Set the "held" flag to prevent super fast cycling
	; sta $0201

    ; LDA #$01
    ; STA $2000

    ; lda #$00        ; Clear the "held" flag
	; sta $0201



    
    ; STA $2001  ;Disable rendering

    ; LDA $2002  
    ; LDA #$3F
    ; STA $2006
    ; LDA #$00
    ; STA $2006

 
    ; LDX #$00                ; start out at 0
    ; LoadPalettesLoopRE:
    ; LDA pallete, X      ; load data from address (PaletteData + the value in x)
    ;                         ; 1st time through loop it will load PaletteData+0
    ;                         ; 2nd time through loop it will load PaletteData+1
    ;                         ; 3rd time through loop it will load PaletteData+2
    ;                         ; etc
    ; ; STA $2007               ; write to PPU
    ; INX                     ; X = X + 1
    ; CPX #$20               ; Compare X to hex $20, decimal 32
    ; BNE LoadPalettesLoopRE

    ; LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    ; STA $2001


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


