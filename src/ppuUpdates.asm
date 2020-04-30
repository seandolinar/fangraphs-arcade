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
    LDA bufferBackgroundTile
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

    RTS
