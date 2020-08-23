
  updateInning:
  JSR startVramBuffer

  @OnesPlace:
  INY                                 ; increments it
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  INY

  LDA #$d4
  STA (vram_lo), Y

  LDX #$00                        
  LDA inningDigit0 , X                ; digits are indexed on 0
  STA tempCatchAll

  INY
  LDX tempCatchAll                    ; X controls the digit
  LDA NUM, X                          ; digit buffer is transformed into tile
  STA (vram_lo), Y

  LDA inning
  CMP #$0a
  BCS @TensPlace
  LDA inningDigit0 + 1
  CMP #$01
  BCS @TensPlace

  JMP endInningUpdate

  @TensPlace:
  INY                                
  LDA #$20
  STA (vram_lo), Y                    ; value should have the tile for the digit
  INY

  LDA #$d3
  STA (vram_lo), Y

  LDX #$01 
  LDA inningDigit0 , X               
  STA tempCatchAll

  INY
  LDX tempCatchAll    
  LDA NUM, X                        ; digit buffer is transformed into tile
  STA (vram_lo), Y

  LDA inning
  CMP #$64
  LDA inningDigit0 + 2
  CMP #$01
  BCS @HundredsPlace

  JMP endInningUpdate

  @HundredsPlace:
  INY                                 
  LDA #$20
  STA (vram_lo), Y                    
  INY

  LDA #$d2
  STA (vram_lo), Y

  LDX #$02 
  LDA inningDigit0 , X                  
  STA tempCatchAll

  INY
  LDX tempCatchAll   
  LDA NUM, X        
  STA (vram_lo), Y

  endInningUpdate:
  STY vram_buffer_offset

  RTS