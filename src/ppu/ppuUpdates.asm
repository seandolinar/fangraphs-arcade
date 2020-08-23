changeBackground:
    LDA PPU_STATUS                ; read PPU status to reset the high/low latch to high
    LDA #$3F
    STA PPU_ADDRESS               ; write the high byte of $3F10 address
    LDA #$10
    STA PPU_ADDRESS               ; write the low byte of $3F10 address

    ; controls the background color
    LDX #$00                        ; start out at 0
    LDA bufferBackgroundColor
    STA PPU_DATA

    ; starts the vram buffer transfer
    LDA #<vram_buffer
    STA vram_lo
    LDA #>vram_buffer
    STA vram_hi

    LDY #$00
    LDA PPU_STATUS               ; read PPU status to reset the high/low latch to high

    @loopVRAMBufferTransfer:
    INY
   
    LDA (vram_lo), Y
    CMP #$00                    ; bails out if we find a #$00 in our stream
    BEQ @dumpLoopVRAMBufferTransfer
    STA PPU_ADDRESS  

    INY     
    LDA (vram_lo), Y
    STA PPU_ADDRESS          

    INY
    LDA (vram_lo), Y
    STA PPU_DATA  


    JMP @loopVRAMBufferTransfer

    @dumpLoopVRAMBufferTransfer:

    RTS


spriteTransfer:       
    ; SPRITE DMA TRANSFER
    LDA #$00
    STA PPU_SPR_ADDR
    LDA #>player_oam
    STA OAM_DMA

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
    STA (vram_lo), Y
    DEY
    CPY #$00
    BNE @loop
    RTS


endGame:
    LDA #$00
	STA PPU_CTRL_REG1               ; disable NMI
	STA PPU_CTRL_REG2  
    RTS
