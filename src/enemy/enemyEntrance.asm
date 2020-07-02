openEnemyDoor:
    JSR startVramBuffer
    INY
    
    LDA #$21
    STA (vram_lo), Y

    INY
    LDA #$10
    STA (vram_lo), Y

    INY
    LDA #$02
    STA (vram_lo), Y

    STY vram_buffer_offset

    RTS