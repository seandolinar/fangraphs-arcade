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
enemy_oam:               .res 8     ; sprite OAM data to be uploaded by DMA
power_up_oam:			 .res 244   ; .res reserves 256 TOTAL bytes of storage
									; will have to expand if when we expand enemies

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
enemyX2:				.res 1 ; 000c
enemyY:                 .res 1 
enemyY2:				.res 1
enemyH:                 .res 1
enemyW:                 .res 1 ; 0010
enemyQ:					.res 1 
enemyXBuffer:			.res 1 
enemyYBuffer:			.res 1

enemyZ:                 .res 1   
enemyZ1:                .res 1 ; 0014
enemyH1:                .res 1 
enemyW1:                .res 1

collisionFlag:          .res 1 
collisionFlagEnemy:     .res 1
collisionTestX:         .res 1 ; 0019
collisionTestY:         .res 1 ; 001a
collisionPointerLo:     .res 1 ; 001b
collisionPointerHi:     .res 1 ; 001c
backgroundPointerLo:    .res 1 ; 001d
backgroundPointerHi:    .res 1 ; 001e


enemyGridX:            .res 1  ; 001f
enemyPointerLo:        .res 1  ; 0020
enemyPointerHi:        .res 1  ; 0021
backgroundPointerLoEnemy:    .res 1 ; 0022
backgroundPointerHiEnemy:    .res 1 ; 0023
collisionPointerLoEnemy:     .res 1 ; 0024
collisionPointerHiEnemy:     .res 1 ; 0025

masterTimer:			.res 1      ; 0026

consoleLogEnemyCollision:	.res 1  ; 0027

gameStateIsPowered: .res 1 ; 0027

; Wish I knew why I can't use the stack for this
tempX:					.res 1
tempY:					.res 1

powerUpX:				.res 1 ;; if these don't move we can read them from ROM
powerUpX2:				.res 1
powerUpX3:				.res 1
powerUpX4:				.res 1
powerUpY:				.res 1 ;; then loop through the locations, though I'd have to remember which ones are "gone"
powerUpY2:				.res 1
powerUpY3:				.res 1
powerUpY4:				.res 1
powerUpAvailable:		.res 1 ; one byte ;; 7654321 - bit one is if the the first one is available
; this might control which powerUp has to be used next
powerUpTimer:			.res 1

background_row:         .res $20
data_x:                 .res 1
data_y:                 .res 1



