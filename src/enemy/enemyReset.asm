enemyReset:
  ; LDA #$80
  ; STA enemyX
  ; LDA #$40
  ; STA enemyY

  LDA #$80
  STA enemyX
  LDA #$38
  STA enemyY

  LDA #$03
  STA enemy1DirectionCurrent



  LDA #$80
  STA enemyX + 1
  LDA #$38
  STA enemyY + 1

  ; LDA #$80
  ; STA enemyX + 1
  ; LDA #$48
  ; STA enemyY + 1

  LDA #$02
  STA enemy2DirectionCurrent

  LDA #$80
  STA enemyX + 2
  LDA #$38
  STA enemyY + 2

  ; LDA #$88
  ; STA enemyX + 2
  ; LDA #$48
  ; STA enemyY + 2

  LDA #$01
  STA enemy3DirectionCurrent

  LDA #$80
  STA enemyX+ 3
  LDA #$38
  STA enemyY + 3

  ; LDA #$88
  ; STA enemyX + 3
  ; LDA #$40
  ; STA enemyY + 3

  LDA #$02
  STA enemy4DirectionCurrent
  RTS