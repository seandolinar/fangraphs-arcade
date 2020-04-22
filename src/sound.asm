.segment "CODE"
soundCollision:

    ; need timer so that the sound will continue to play if we are sitting on it
    LDA masterTimer
    ; CMP #$00
    ; BNE dumpSoundCollision
    ; this makes it go on forever...don't know why
    ; because 5th bit (from right) disables the length counter
    ; LDA #%10111111;
    ; STA $4000
    LDA #$ff    ;0C9 is a C# in NTSC mode
    STA $4002
    LDA #$02 ;LDA %11110000;
    STA $4003

dumpSoundCollision:
    RTS



soundCollisionGood:

    ; need timer so that the sound will continue to play if we are sitting on it
    LDA masterTimer
    ; CMP #$00
    ; BNE dumpSoundCollision
    ; this makes it go on forever...don't know why
    ; because 5th bit (from right) disables the length counter
    ; LDA #%10111111;
    ; STA $4000
    LDA #$ff    ;0C9 is a C# in NTSC mode
    STA $4002
    LDA %11111111;
    STA $4003

dumpSoundCollisionGood:
    RTS


soundDot:

    ; need timer so that the sound will continue to play if we are sitting on it
    LDA masterTimer
    ; CMP #$00
    ; BNE dumpSoundCollision
    ; this makes it go on forever...don't know why
    ; because 5th bit (from right) disables the length counter
    ; LDA #%10111111;
    ; STA $4000
    LDA #$ff    ;0C9 is a C# in NTSC mode
    STA $4002
    LDA %11111111;
    STA $4003

    ; ENABLE SOUND
    lda #%00000000
    sta $4015 ;enable square 1

    lda #%00000001
    sta $4015 ;enable square 1

    LDA #$f0    ;0C9 is a C# in NTSC mode
    STA $4002
    LDA %11001100;
    STA $4003

dumpSoundDot:
    RTS