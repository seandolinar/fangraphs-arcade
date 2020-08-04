enemyReset:

  LDA #$80
  STA enemyX
  LDA #$38
  STA enemyY

  LDA #DIRECTION_RIGHT
  STA enemy1DirectionCurrent


  LDA #$80
  STA enemyX + 1
  LDA #$38
  STA enemyY + 1

  LDA #DIRECTION_DOWN
  STA enemy2DirectionCurrent

  LDA #$80
  STA enemyX + 2
  LDA #$38
  STA enemyY + 2

  LDA #DIRECTION_LEFT
  STA enemy3DirectionCurrent

  LDA #$80
  STA enemyX+ 3
  LDA #$38
  STA enemyY + 3

  LDA #DIRECTION_DOWN
  STA enemy4DirectionCurrent
  RTS