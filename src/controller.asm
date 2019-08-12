.segment "CODE"
readController:



    LatchController:
        LDA controllerBits
        STA controllerBitsPrev
        LDA #$00
        STA controllerBits

        LDA #$01
        STA $4016
        LDA #$00
        STA $4016       ; tell both the controllers to latch buttons
        STA controllerBits
   

    ; we'll read 4016 8 times
    ReadA: 

        LDA $4016       
        AND #%00000001  ;
        BEQ ReadADone  

        LDA controllerBits
        ORA #%00000001
        STA controllerBits

    ReadADone:

    ReadB: 
        LDA $4016      
        AND #%00000001  
        BEQ ReadBDone  

        LDA controllerBits
        ADC #%00000010
        STA controllerBits
        
        
    ReadBDone:

     ReadSelect: 
        LDA $4016       
        AND #%00000001  
        BEQ ReadSelectDone   

        LDA controllerBits
        ADC #%00000100
        STA controllerBits
        
    ReadSelectDone:

     ReadStart: 
        LDA $4016      
        AND #%00000001 
        BEQ ReadStartDone  
        
        LDA controllerBits
        ADC #%00001000
        STA controllerBits

    ReadStartDone:

    ReadUp: 
        LDA $4016      
        AND #%00000001 
        BEQ ReadUpDone  
     

        LDA controllerBits
        ADC #%00010000
        STA controllerBits

    ReadUpDone:

    ReadDown: 
        LDA $4016       
        AND #%00000001  
        BEQ ReadDownDone   

        LDA controllerBits
        ADC #%00100000
        STA controllerBits

    ReadDownDone:

    ReadLeft: 
        LDA $4016       
        AND #%00000001 
        BEQ ReadLeftDone   

        LDA controllerBits
        ADC #%01000000
        STA controllerBits
        
    ReadLeftDone:

    ReadRight: 
        LDA $4016      
        AND #%00000001  
        BEQ ReadRightDone   

        LDA controllerBits
        ADC #%10000000
        STA controllerBits
        
    ReadRightDone:

    LDA controllerBits ; probably don't need this
    BEQ resetTimer
    LDA controllerTimer
    BNE dumpTimerController
    LDA #$10
    STA controllerTimer
    RTS


resetTimer:
    LDA #$00
    STA controllerTimer
    STA controllerBits
    RTS

dumpTimerController:
    LDA #$00 
    STA controllerBits

    DEC controllerTimer

    RTS
