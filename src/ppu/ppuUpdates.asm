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

; move
checkDoor:

    TXA
    PHA

    LDX #$03
    LDA #$00
    STA shouldDoorClose

    @loop:
    LDA enemyState, X
    CMP #$02
    BEQ @openDoor
    JMP @continue

    @vramOpenDoor:
    .byte $21, $0f, $49
    .byte $21, $10, $49 
    .byte $21, $11, $49
    .byte $20, $ef, $45
    .byte $20, $f0, $45
    .byte $20, $f1, $45

    @vramCloseDoor:
    .byte $21, $0f, $05
    .byte $21, $10, $05 
    .byte $21, $11, $05
    .byte $20, $ef, __T
    .byte $20, $f0, __S
    .byte $20, $f1, $36

    @openDoor:
    TXA 
    PHA

    LDA #$01
    STA shouldDoorClose
    
    LDX #$00
    JSR startVramBuffer
    
    @vramLoop:
    INY
    LDA @vramOpenDoor, X
    STA (vram_lo), Y

    INX
    CPX #$12
    BNE @vramLoop

    PLA
    TAX

    STY vram_buffer_offset 
    JMP @continue

    @closeDoor:
    TXA 
    PHA
    
    LDX #$00
    JSR startVramBuffer
    
    @vramLoopClose:
    INY
    LDA @vramCloseDoor, X
    STA (vram_lo), Y

    INX
    CPX #$15
    BNE @vramLoopClose

    PLA
    TAX

    STY vram_buffer_offset
    JMP @exit

    @continue:
    DEX
    CPX #$00
    BNE @loop

    ; we need to loop through and if we find no 2s then close
    LDX #$03
    @loopStateNormal:
    LDA enemyState, X
    CMP #$02
    BEQ @exit

    CPX #$00
    BEQ @closeDoor
    DEX
    JMP @loopStateNormal

    @exit:
    PLA
    TAX
    RTS