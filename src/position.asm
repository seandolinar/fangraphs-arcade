.segment "CODE"
updatePosition:


  LDA controllerBits
  AND #CONTROL_P1_UP ;UP
  BEQ dumpControlUp ; dumps if we have no A push
  LDA playerLocationY
  SEC
  SBC #$01
  STA playerLocationY
dumpControlUp:
  LDA controllerBits
  AND #CONTROL_P1_DOWN ;UP
  BEQ dumpControlDown ; dumps if we have no A push
  LDA playerLocationY
  CLC
  ADC #$01
  STA playerLocationY
dumpControlDown:
  LDA controllerBits
  AND #CONTROL_P1_LEFT ;UP
  BEQ dumpControlLeft ; dumps if we have no A push
  LDA playerLocationX
  SEC
  SBC #$01
  STA playerLocationX
dumpControlLeft:
  LDA controllerBits
  AND #CONTROL_P1_RIGHT ;UP
  BEQ dumpUpdatePosition ; dumps if we have no A push
  LDA playerLocationX
  CLC
  ADC #$01
  STA playerLocationX
  

dumpUpdatePosition:
    LDA playerLocationX
    STA $0203

    LDA playerLocationY
    STA $0200


    RTS
