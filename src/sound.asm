.segment "CODE"
soundCollision:

    TXA
    PHA
    LDA #$01

    ldx #FT_SFX_CH0
	jsr FamiToneSfxPlay

    PLA
    TAX

dumpSoundCollision:
    RTS



soundCollisionGood:
    TXA
    PHA
    LDA #$01

    ldx #FT_SFX_CH0
	jsr FamiToneSfxPlay

    PLA
    TAX

dumpSoundCollisionGood:
    RTS


soundDot:
    TXA
    PHA
    LDA #$00

    LDX #FT_SFX_CH0
	JSR FamiToneSfxPlay
    PLA
    TAX

dumpSoundDot:
    RTS