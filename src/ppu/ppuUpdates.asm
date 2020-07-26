changeBackground:
; background
; I don't have to turn this off
; I'm not sure why
    ; LDA #$00
	; STA $2000               ; disable NMI
	; STA $2001               ; disable rendering

    LDA $2002               ; read PPU status to reset the high/low latch to high
    LDA #$3F
    STA $2006               ; write the high byte of $3F10 address
    LDA #$10
    STA $2006               ; write the low byte of $3F10 address

    ; controls the background color
    LDX #$00                ; start out at 0
    LDA bufferBackgroundColor
    STA $2007

    ; starts the vram buffer transfer
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY #$00
    LDA $2002               ; read PPU status to reset the high/low latch to high

    @loopVRAMBufferTransfer:
    INY
   
    LDA (vram_lo), Y
    CMP #$00 ; bails out if we find a #FF in our stream
    BEQ @dumpLoopVRAMBufferTransfer
    STA $2006  

    INY     
    LDA (vram_lo), Y
    STA $2006          

    INY
    LDA (vram_lo), Y
    STA $2007  


    JMP @loopVRAMBufferTransfer

    @dumpLoopVRAMBufferTransfer:

    RTS


spriteTransfer:       
    ; SPRITE TRANSFER
    ; does this every frame
    LDA #$00
    STA $2003               ; set the low byte (00) of the RAM address
    LDA #>player_oam        ; this works and so does $02
    STA $4014               ; set the high byte (02) of the RAM address, start the transfer

    RTS


clearVRAMBuffer:
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY #$40

    LDA #$00
    STA vram_buffer_offset
    LDA #$00
    @loop:
    STA (vram_lo), Y ; not working
    DEY
    CPY #$00
    BNE @loop
    RTS


endGame:
    LDA #$00
	STA $2000               ; disable NMI
	STA $2001  
    RTS


checkDoor:

    TXA
    PHA

    LDX #$03

    @loop:
    LDA enemyState, X
    CMP #$02
    BEQ @openDoor
    JMP @continue

    @openDoor:
    JSR startVramBuffer
    
    INY
    LDA #$21
    STA (vram_lo), Y

    INY
    LDA #$0f
    STA (vram_lo), Y

    INY
    LDA #$02
    STA (vram_lo), Y

    ;;;
    INY
    LDA #$21
    STA (vram_lo), Y

    INY
    LDA #$10
    STA (vram_lo), Y

    INY
    LDA #$02
    STA (vram_lo), Y

    ;;
    INY
    LDA #$21
    STA (vram_lo), Y

    INY
    LDA #$11
    STA (vram_lo), Y

    INY
    LDA #$02
    STA (vram_lo), Y

    STY vram_buffer_offset

    @continue:
    DEX
    CPX #$00
    BNE @loop


    @exit:
    PLA
    TAX
    RTS