.segment "CODE"
readController:

    LatchController:
        LDA controllerBits
        STA controllerBitsPrev
        LDA #$00
        STA controllerBits

        LDA #$01
        STA CONTROLLER_P1
        LDA #$00
        ; STA controllerBits
        STA CONTROLLER_P1      ; tell both the controllers to latch buttons
   
    ; we'll read 4016 8 times
    ReadA: 

        LDA CONTROLLER_P1      
        AND #%00000001  ;
        BEQ ReadADone  

        CLC
        LDA controllerBits
        ADC #%00000001
        STA controllerBits

    ReadADone:

    ReadB: 
        LDA CONTROLLER_P1      
        AND #%00000001  
        BEQ ReadBDone  

        CLC
        LDA controllerBits
        ADC #%00000010
        STA controllerBits
        
        
    ReadBDone:

     ReadSelect: 
        LDA CONTROLLER_P1     
        AND #%00000001  
        BEQ ReadSelectDone   

        CLC
        LDA controllerBits
        ADC #%00000100
        STA controllerBits
        
    ReadSelectDone:

     ReadStart: 
        LDA CONTROLLER_P1      
        AND #%00000001 
        BEQ ReadStartDone  
        
        CLC
        LDA controllerBits
        ADC #%00001000
        STA controllerBits

    ReadStartDone:

    ReadUp: 
        LDA CONTROLLER_P1     
        AND #%00000001 
        BEQ ReadUpDone  
     
        CLC
        LDA controllerBits
        ADC #%00010000
        STA controllerBits

    ReadUpDone:

    ReadDown: 
        LDA CONTROLLER_P1   
        AND #%00000001  
        BEQ ReadDownDone   

        CLC
        LDA controllerBits
        ADC #%00100000
        STA controllerBits

    ReadDownDone:

    ReadLeft: 
        LDA CONTROLLER_P1       
        AND #%00000001 
        BEQ ReadLeftDone   

        CLC
        LDA controllerBits
        ADC #%01000000
        STA controllerBits
        
    ReadLeftDone:

    ReadRight: 
        LDA CONTROLLER_P1      
        AND #%00000001  
        BEQ ReadRightDone   

        CLC
        LDA controllerBits
        ADC #%10000000
        STA controllerBits
        
    ReadRightDone:

    RTS
