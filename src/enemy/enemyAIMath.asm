;;;;;;;;;;;;;;;;
;; Math Utils ;;
;;;;;;;;;;;;;;;;
absX:
    LDA enemyXBuffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA enemyGridX

    CMP playerGridXAI
    BEQ @equal
    BCS @subtractSwap                   

    @subtractNormal:
    SEC
    LDA playerGridXAI
    SBC enemyGridX
    JMP @break

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridXAI
    JMP @break

    @equal:
    LDA #$00

    @break:
    STA enemyAbsX
    RTS

absY:
    LDA enemyYBuffer
    LSR ; divide / 2 / 2 / 2 ; divide by 8 -- size of the icon
    LSR
    LSR
    STA enemyGridX

    CMP playerGridYAI
    BEQ @equal
    BCS @subtractSwap

    @subtractNormal:
    SEC
    LDA playerGridYAI
    SBC enemyGridX
    JMP @dump

    @subtractSwap:
    SEC
    LDA enemyGridX
    SBC playerGridYAI

    @equal:
    LDA #$00

    @dump:
    STA enemyAbsY
    RTS

computeSquare:
    TXA
    PHA

    LDX sqIn
    LDA sqIn

    STA sqOut
    LDA #$00
    STA sqOut + 1

    CPX #$00
    BEQ @dump
    CPX #$01
    BEQ @dump
    
    DEX
    @additionLoop:
    CLC
    LDA sqOut               ; low byte
    ADC sqIn
    STA sqOut

    LDA sqOut + 1           ; high byte
    ADC #$00
    STA sqOut + 1

    DEX
    BNE @additionLoop

    @dump:
    PLA
    TAX

    RTS

;; figure out how to make this work
computeDistance:

    TYA
    PHA

    TXA                               ; stash X to calculate Y 
    PHA

    LDY #$00
    @loopY:                           ; multiple X by two to get Y
    CPX #$00
    BEQ @runComp
    INY
    INY
    DEX
    JMP @loopY
    
    @runComp:
    PLA                                ; bring back X
    TAX

    JSR absX                           ; hopefully loop this
    LDA enemyAbsX
    STA sqIn                           ; change this? would need to be 16-bit
    JSR computeSquare

    CLC
    LDA sqOut
    STA enemyDistance, Y               ; lo byte
    LDA sqOut + 1
    STA enemyDistance + 1, Y           ; hi byte

    JSR absY
    STA sqIn                           ; change this? would need to be 16-bit
    JSR computeSquare

    CLC
    LDA sqOut
    ADC enemyDistance, Y
    STA enemyDistance, Y

    CLC
    LDA sqOut + 1
    ADC enemyDistance + 1, Y
    STA enemyDistance + 1, Y

    PLA
    TAY

    RTS



