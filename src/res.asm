;TEMPORARY CONSTANT ADDRESSES
CONTROL_P1_A =      %00000001 
CONTROL_P1_B =      %00000010 
CONTROL_P1_SELECT = %00000100 
CONTROL_P1_START =  %00001000 
CONTROL_P1_UP =     %00010000 
CONTROL_P1_DOWN =   %00100000 
CONTROL_P1_LEFT =   %01000000 
CONTROL_P1_RIGHT =  %10000000 





.segment "VECTORS" ; ADDRESSES FOR INTERUPTS
.word NMI
.word RESET
.word IRQ


.segment "OAM"
player_oam:              .res 4
enemy_oam:               .res 252        ; sprite OAM data to be uploaded by DMA
					                        ; .res reserves 256 bytes of storage


.segment "ZEROPAGE"
playerLocationX:        .res 1 ; 0000
playerLocationY:        .res 1
playerLocationXBuffer:  .res 1
playerLocationYBuffer:  .res 1 
playerGridX:            .res 1 ; 0004
playerGridY:            .res 1
playerPointerLo:        .res 1
playerPointerHi:        .res 1

controllerBits:         .res 1 ; 0008
controllerBitsPrev:     .res 1
controllerTimer:        .res 1

enemyX:                 .res 1   
enemyY:                 .res 1 ; 000c
enemyH:                 .res 1
enemyW:                 .res 1
enemyQ:					.res 1
enemyXBuffer:			.res 1 ; 0010
enemyYBuffer:			.res 1

enemyX1:                .res 1   
enemyY1:                .res 1
enemyH1:                .res 1 ; 0014
enemyW1:                .res 1

collisionFlag:          .res 1 
collisionFlagEnemy:     .res 1
collisionTestX:         .res 1 ; 0018
collisionTestY:         .res 1 ; 0019
collisionPointerLo:     .res 1 ; 001a
collisionPointerHi:     .res 1 ; 001b
backgroundPointerLo:    .res 1 ; 001c
backgroundPointerHi:    .res 1 ; 001d


enemyGridX:            .res 1  ; 001e
enemyPointerLo:        .res 1  ; 001f
enemyPointerHi:        .res 1  ; 0020
backgroundPointerLoEnemy:    .res 1 ; 0021
backgroundPointerHiEnemy:    .res 1 ; 0022
collisionPointerLoEnemy:     .res 1 ; 0023
collisionPointerHiEnemy:     .res 1 ; 0024

masterTimer:			.res 1      ; 0025

consoleLogEnemyCollision:	.res 1  ; 0026

gameStateIsPowered: .res 1 ; 0027


background_row:         .res $20
data_x:                 .res 1
data_y:                 .res 1



