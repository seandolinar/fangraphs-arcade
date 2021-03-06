NMI:
    ; Preserves the registers during the course of the interrupt
    PHA
    TXA
    PHA
    TYA
    PHA

    LDA gameOuts
    CMP #$03
    BEQ @endGame

    INC frameTimer

    JSR changeBackground
    JSR spriteTransfer


    ; STARTS VIDEO DISPLAY
    LDA PPUState                ; using state from the code
    STA PPU_CTRL_REG1

    LDA #%00011110          
    STA PPU_CTRL_REG2

    ; resets scroll
    ; not sure why I have to do this, but it works!!
    LDA #$00
    STA PPU_SCROLL_REG 
    STA PPU_SCROLL_REG

    LDA gamePlayerReset         ; $01 means we are in the middle of a reset
    BNE @resetNMI

    LDX masterTimer
    DEX
    STX masterTimer
    BNE @dumpNMI
    LDA #$08               
    STA masterTimer

@dumpNMI:

    JSR FamiToneUpdate		    ; update sound

    JSR clearVRAMBuffer

    CLC
    LDA frameTimer
    CMP buttonDelay
    BNE @continue

    LDA #$00
    STA konamiCode

    @continue:
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

@resetNMI:

    JSR FamiToneUpdate		;update sound

    ; maybe spin this off?
    ; or spin off of all NMI
    JSR readController
    LDA controllerBits
    EOR controllerBitsPrev ; difference in buttons
    AND controllerBits
    AND #CONTROL_P1_A  ; zeros out non-start bits
    BNE @continuePlayerReset

    CLC
    LDA frameTimer
    CMP frameDelay
    BNE @dumpReset

    @continuePlayerReset:
    LDA #$00
    STA gamePlayerReset

    @dumpReset:
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI

@endGame:
    ; kills the game at three outs
    RTI