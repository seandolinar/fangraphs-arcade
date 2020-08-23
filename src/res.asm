.segment "VECTORS" ; ADDRESSES FOR INTERUPTS
.word NMI
.word RESET
.word IRQ


.segment "OAM"
player_oam:              .res 32
enemy_oam:               .res 64     ; sprite OAM data to be uploaded by DMA
power_up_oam:			 .res 160   ; .res reserves 256 TOTAL bytes of storage
									; will have to expand if when we expand enemies

.segment "ZEROPAGE"
; 00_player
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

; 01_enemy
enemyX:                 .res 4 ; 000b - 000e
enemyY:                 .res 4 ; 000f - 0012

enemyMode:				.res 1 ; 0013
enemyXBuffer:			.res 1 ; 0014
enemyYBuffer:			.res 1 ; 0015

; 02_collision
collisionFlag:          .res 1 	; 0016
collisionFlagEnemy:     .res 1	; 0017
collisionTestX:         .res 1 	; 0018
collisionTestY:         .res 1 	; 0019
collisionPointerLo:     .res 1 	; 001a
collisionPointerHi:     .res 1 	; 001b
backgroundPointerLo:    .res 1 	; 001c
backgroundPointerHi:    .res 1 	; 001d

enemyGridX:            		.res 1  ; 001e
enemyPointerLo:        		.res 1  ; 001f
enemyPointerHi:        		.res 1  ; 0020
backgroundPointerLoEnemy:   .res 1	; 0021
backgroundPointerHiEnemy:   .res 1 	; 0022
collisionPointerLoEnemy:    .res 1 	; 0023
collisionPointerHiEnemy:    .res 1 	; 0024

; 03_timing_util
masterTimer:				.res 1  ; 0025
animationTimer:				.res 1  ; 0026
frameTimer:					.res 1  ; 0027

consoleLog:					.res 1  ; 0028

gameStateIsPowered: 		.res 1 ; 0029

; Sometimes this works better than stack
tempX:						.res 1 ; 002a
tempY:						.res 1 ; 002b

powerUpAvailable:			.res 1 ; 002c 
powerUpTimer:				.res 1 ; 002d

bufferBackgroundColor:		.res 1 ; 002e
bufferBackgroundValLo:		.res 1
bufferBackgroundValHi:		.res 1

dotsLeft:					.res 1	;0031 ; this might need to be 2 bytes
inning:						.res 1	

; enemy AI
playerDirectionCurrent:			.res 1 ; 0033
enemy1DirectionCurrent:			.res 1 ; 0034
enemy2DirectionCurrent:			.res 1
enemy3DirectionCurrent:			.res 1
enemy4DirectionCurrent:			.res 1

enemyState:						.res 4 ; 0038-003B

enemyXWork:						.res 1 ; 003C
enemyYWork:						.res 1 ; 003D

enemyCMPTemp:					.res 1 ; 003E
enemyAbsX:						.res 1 ; 003F
enemyAbsY:						.res 1 ; 0040
sqIn:							.res 1 ; 0041
sqX:							.res 2 ; 0042, 0043
sqY:							.res 2 ; 0044, 0045
sumXY:							.res 2 ; 0046, 0047 

enemyDistance:					.res 6 ; 0048-004c
enemyDirectionArray:			.res 3 ; 004e, 004f, 0050

sqOut:							.res 2 ; 0051, 0052


enemyTempForLoop:				.res 1 ; 0053
enemyDirectionIndex:			.res 1 ; 0054 
enemyBufferDirectionCurrent:	.res 1 ; 0055


nametable_buffer_lo:			.res 1
nametable_buffer_hi:			.res 1

bufferBackgroundTile:			.res 1 ; 007D
collisionBackgroundTile:		.res 1 ; 007E
controlTimer:					.res 1 ; 007F

playerGridXAI:					.res 1 ; 0080
playerGridYAI:					.res 1 ; 0081

gamePaused:						.res 1 ; 0086 
PPUState:						.res 1 ; 0087
PPUState2:						.res 1 ; 0088
gamePlayerReset:				.res 1 ; 0089
gameOuts:						.res 1 ; 008a

scoreLo:						.res 1 ; 008b
vram_lo:						.res 1 ; 008c
vram_hi:						.res 1 ; 008d

; score
scoreDigit0:			.res 1 ; 0087
scoreDigit1:			.res 1 ; 
scoreDigit2:			.res 1 ; 
scoreDigit3:			.res 1 ; 
scoreDigit4:			.res 1
scoreDigit5:			.res 1
scoreDigit6:			.res 1
scoreDigit7:			.res 1
scoreDigit8:			.res 1
scoreDigit9:			.res 1
scoreDigit10:			.res 1	; 0090
scoreDigit11:			.res 1 	; 0091 
scoreDigitBuffer:		.res 1
scoreValue:				.res 1	; 0093

inningDigit0:			.res 1 ; 0096?
inningDigit1:			.res 1
inningDigit2:			.res 1

tempX1:					.res 1
tempCatchAll:			.res 1
enemyCycleX:			.res 1
isEnemyLeaving:			.res 1
frameDelay:				.res 1
enemyAIIndex:			.res 1
buttonDebounce:			.res 1
buttonDelay:			.res 1
konamiCode:				.res 1
hasCheated:				.res 1



; NES-defined RAM locations
PPU_CTRL_REG1         	= $2000
PPU_CTRL_REG2         	= $2001
PPU_STATUS            	= $2002
PPU_SPR_ADDR          	= $2003
PPU_SPR_DATA          	= $2004
PPU_SCROLL_REG       	= $2005
PPU_ADDRESS           	= $2006
PPU_DATA         		= $2007

OAM_DMA 				= $4014

; Controller values
CONTROLLER_P1 			= $4016

CONTROL_P1_A 			= %00000001 
CONTROL_P1_B 			= %00000010 
CONTROL_P1_SELECT 		= %00000100 
CONTROL_P1_START 		= %00001000 
CONTROL_P1_UP 			= %00010000 
CONTROL_P1_DOWN 		= %00100000 
CONTROL_P1_LEFT 		= %01000000 
CONTROL_P1_RIGHT 		= %10000000 

; TEXT constants
; alphabetical 
APH					  	= $d0
__A					  	= $d0
__B					  	= $d1
__C					  	= $d2
__D					  	= $d3
__E					  	= $d4
__F					  	= $d5
__G						= $d6
__H						= $d7
__I						= $d8
__J						= $d9
__K						= $da
__L						= $db
__M						= $dc
__N						= $dd
__O 				  	= $de
__P						= $df
__Q						= $e0
__R						= $e1
__S						= $e2
__T						= $e3
__U						= $e4
__V						= $e5
__W						= $e6
__X						= $e7
__Y						= $e8
__Z						= $e9

;numeric 
__0					  	= $f0
__1					  	= $f1

;constant
;directions
DIRECTION_UP 			= $01
DIRECTION_DOWN			= $02
DIRECTION_LEFT			= $03
DIRECTION_RIGHT			= $04

; enemy states
ENEMY_STATE_GAME_PLAY	= $00
ENEMY_STATE_BATTED		= $01
ENEMY_STATE_DOOR		= $02
ENEMY_STATE_HALT		= $ff

.segment "RAM"
nametable_buffer:		.res $3c0 	; 960 blocks
vram_buffer_offset:		.res $01	; 1 byte offset $06C2
vram_buffer:			.res $40	; 32 		   +$0040 = $0702



; BASE CORDINATES -- HARD CODED 
.segment "CODE"
powerUpX:
.byte $e8, $80, $10, $80, $ff
powerUpY:
.byte $60, $10, $60, $d0, $ff

