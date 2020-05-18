enemyReset:
  LDA #$A0
  STA enemyX
  LDA #$58
  STA enemyY

  LDA #$03
  STA enemy1DirectionCurrent

  LDA #$A0
  STA enemyX2
  LDA #$50
  STA enemyY2

  LDA #$02
  STA enemy2DirectionCurrent

  LDA #$80
  STA enemyX3
  LDA #$50
  STA enemyY3

  LDA #$01
  STA enemy3DirectionCurrent

  LDA #$80
  STA enemyX4
  LDA #$50
  STA enemyY4

  LDA #$02
  STA enemy4DirectionCurrent
  RTS