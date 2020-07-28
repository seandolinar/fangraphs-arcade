 vramOpenDoor:
    .byte $21, $0f, $49
    .byte $21, $10, $49 
    .byte $21, $11, $49
    .byte $20, $ef, $45
    .byte $20, $f0, $45
    .byte $20, $f1, $45

vramCloseDoor:
    .byte $21, $0f, $05
    .byte $21, $10, $05 
    .byte $21, $11, $05
    .byte $20, $ef, __T
    .byte $20, $f0, __S
    .byte $20, $f1, $36


checkDoor:

    TXA
    PHA

    LDX #$03

    @loop:
    LDA enemyState, X
    CMP #$02
    BEQ @openDoor
    DEX
    CPX #$00
    BNE @loop

    JMP @checkIfDoorClose
   
    @openDoor:
    TXA 
    PHA
    
    LDX #$00
    JSR startVramBuffer
    
    @vramLoop:
    INY
    LDA vramOpenDoor, X
    STA (vram_lo), Y

    INX
    CPX #$12
    BNE @vramLoop

    PLA
    TAX

    STY vram_buffer_offset 
    JMP @exit

    @closeDoor:
    TXA 
    PHA
    
    LDX #$00
    JSR startVramBuffer
    
    @vramLoopClose:
    INY
    LDA vramCloseDoor, X
    STA (vram_lo), Y

    INX
    CPX #$15
    BNE @vramLoopClose

    PLA
    TAX

    STY vram_buffer_offset
    JMP @exit

    

    @checkIfDoorClose:
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