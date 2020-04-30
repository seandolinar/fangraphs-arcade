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
player_oam:              .res 32
enemy_oam:               .res 16     ; sprite OAM data to be uploaded by DMA
power_up_oam:			 .res 204   ; .res reserves 256 TOTAL bytes of storage
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
enemyX3:				.res 1
enemyX4:				.res 1

enemyY:                 .res 1 
enemyY2:				.res 1 ; 0010
enemyY3:				.res 1
enemyY4:				.res 1

enemyH:                 .res 1
enemyW:                 .res 1 ; 0014
enemyQ:					.res 1 
enemyXBuffer:			.res 1 
enemyYBuffer:			.res 1	; 0017

enemyNextDirection:     .res 1	; 0018   
enemyZ1:                .res 1  ; 0019
enemyH1:                .res 1  ; 001a
enemyGridY:             .res 1  ; 001b ; move this

collisionFlag:          .res 1 	; 001c
collisionFlagEnemy:     .res 1	; 001d
collisionTestX:         .res 1 	; 001e
collisionTestY:         .res 1 	; 001f
collisionPointerLo:     .res 1 	; 0020
collisionPointerHi:     .res 1 	; 0021
backgroundPointerLo:    .res 1 	; 0022
backgroundPointerHi:    .res 1 	; 0023


enemyGridX:            		.res 1  ; 0024
enemyPointerLo:        		.res 1  ; 0025
enemyPointerHi:        		.res 1  ; 0026
backgroundPointerLoEnemy:   .res 1	; 0027
backgroundPointerHiEnemy:   .res 1 	; 0028
collisionPointerLoEnemy:    .res 1 	; 0029
collisionPointerHiEnemy:    .res 1 	; 002a

masterTimer:				.res 1      ; 0026

consoleLog:					.res 1  ; 002C

gameStateIsPowered: 		.res 1 ; 002D

; Wish I knew why I can't use the stack for this
tempX:					.res 1 ; 002E
tempY:					.res 1 ; 002F

powerUpX:				.res 1 ; 0030 ;; if these don't move we can read them from ROM
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

bufferBackgroundColor:	.res 1
bufferBackgroundValLo:	.res 1
bufferBackgroundValHi:	.res 1

dotsLeft:				.res 1

background_row:         .res $20
data_x:                 .res 1
data_y:                 .res 1

nametable_buffer_lo:	.res 1
nametable_buffer_hi:	.res 1

; move this
playerDirectionCurrent:	.res 1
enemy1DirectionCurrent:	.res 1
enemy2DirectionCurrent:	.res 1
enemy3DirectionCurrent:	.res 1
enemy4DirectionCurrent:	.res 1


enemyXWork:				.res 1
enemyYWork:				.res 1

enemyCMPTemp:			.res 1
enemyAbsX:				.res 1
enemyAbsY:				.res 1
sqIn:					.res 1
sqX:					.res 2
sqY:					.res 2
sumXY:					.res 2

enemyDistance:			.res 6
enemyDirectionArray:	.res 3

sqOut:					.res 2


enemyTempForLoop:		.res 1
enemyDirectionIndex:	.res 1
enemyBufferDirectionCurrent:	.res 1

bufferBackgroundTile:	.res 1




; NES-defined RAM locations
PPU_CTRL_REG1         = $2000
PPU_CTRL_REG2         = $2001
PPU_STATUS            = $2002
PPU_SPR_ADDR          = $2003
PPU_SPR_DATA          = $2004
PPU_SCROLL_REG        = $2005
PPU_ADDRESS           = $2006
PPU_DATA              = $2007


.segment "RAM"
nametable_buffer:		.res $3C0
