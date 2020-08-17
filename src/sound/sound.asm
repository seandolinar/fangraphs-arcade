.segment "CODE"
soundCollision:

    TXA
    PHA
    LDA #$00

    ; ldx #FT_SFX_CH0
	; jsr FamiToneSfxPlay
    LDA #$02
	JSR FamiToneMusicPlay

    PLA
    TAX

dumpSoundCollision:
    RTS



soundCollisionGood:
    TXA
    PHA
    STX tempX

    LDA #$03

    LDX #FT_SFX_CH0
	JSR FamiToneSfxPlay

    PLA
    TAX
    LDX tempX
    RTS


soundDot:
    TXA
    PHA
    LDA #$01

    LDX #FT_SFX_CH1
	JSR FamiToneSfxPlay
    PLA
    TAX
    RTS

soundNextInning:
    TXA
    PHA
    LDA #$02
    LDX #FT_SFX_CH0
    JSR FamiToneSfxPlay
    PLA
    TAX
    RTS


soundPowerUp:
    TXA
    PHA

    LDX #FT_SFX_CH0
    LDA #$00
    JSR FamiToneSfxPlay

    PLA
    TAX
    RTS

soundHomePlateWin:
    TXA
    PHA
    
    LDX #FT_SFX_CH0
    LDA #$04
    JSR FamiToneSfxPlay

    PLA
    TAX
    RTS