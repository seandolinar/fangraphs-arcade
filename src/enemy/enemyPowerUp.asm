changeEnemyColor:

    TXA
    PHA
    TYA
    PHA

    LDY #$00

    LDA gameStateIsPowered
    BNE changeEnemyColorPowerUp 


    changeEnemyColorPowerDown:
    ; pallete attribute for the power up
    LDA #%0000000 ; yellow ; return them to normal

    JSR resetEnemyColorLoop

    JSR startVramBuffer
    INY

    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$1d
    STA (vram_lo), Y

    INY
    LDA #$0F
    STA (vram_lo), Y


    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$1f
    STA (vram_lo), Y

    ; pallete changes for flashing ball 
    INY
    LDA #$25
    STA (vram_lo), Y

    ;;;
    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$13
    STA (vram_lo), Y

    INY
    LDA #$21
    STA (vram_lo), Y

    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$13
    STA (vram_lo), Y

    INY
    LDA #$21
    STA (vram_lo), Y

    STY vram_buffer_offset

    @exit:

    PLA
    TAY
    PLA
    TAX

    RTS
   
changeEnemyColorPowerUp:
    LDA #%00000011 ; POWER UP STATE ; RED

    JSR changeEnemyColorLoop

    JSR startVramBuffer
    INY

    ;;
    LDA #$3F
    STA (vram_lo), Y

    INY

    LDA #$1d
    STA (vram_lo), Y

    INY
    LDA #$16
    STA (vram_lo), Y

    ;;;;
    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$1f
    STA (vram_lo), Y

    
    INY
    LDA #$20
    STA (vram_lo), Y
    
    ;;;
    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$13
    STA (vram_lo), Y

    
    INY
    LDA #$20
    STA (vram_lo), Y

    ;;;
    INY
    LDA #$3F
    STA (vram_lo), Y

    INY
    LDA #$17
    STA (vram_lo), Y

    INY
    LDA #$26
    STA (vram_lo), Y


    STY vram_buffer_offset

    PLA
    TAY
    PLA
    TAX

    RTS

; maybe make a reset color one instead of 1    
; if an enemy is in the middle of auto control, it will retain #$01 as a pallete index
resetEnemyColorLoop:
    LDX #$04
    LDY #$00

    @loop:
    DEX

    ; controls the sprite pallete attribute
    TXA
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    ; adds 16 to Y
    PHA
    CLC
    TYA
    ADC #$10
    TAY
    PLA

    CPX #$00
    BNE @loop

    RTS



changeEnemyColorLoop:
    ; A register needs to be "passed" in
    ; I only call this once
    LDY #$00
    LDX #$04
    @loop:
    ; controls the sprite pallete attribute
    DEX
    STA enemy_oam + 2, Y
    STA enemy_oam + 6, Y
    STA enemy_oam + 10, Y
    STA enemy_oam + 14, Y

    ; adds 16 to Y
    PHA
    CLC
    TYA
    ADC #$10
    TAY
    PLA

    CPX #$00
    BEQ @break
    JMP @loop

    @break:
    RTS