;TEMPORARY CONSTANT ADDRESSES
CONTROL_P1_A =      %00000001 
CONTROL_P1_B =      %00000010 
CONTROL_P1_SELECT = %00000100 
CONTROL_P1_START =  %00001000 
CONTROL_P1_UP =     %00010000 
CONTROL_P1_DOWN =   %00100000 
CONTROL_P1_LEFT =   %01000000 
CONTROL_P1_RIGHT =  %10000000 


; famitone 2
; FT_BASE_ADR		= $0700	;page in the RAM used for FT2 variables, should be $xx00
; FT_TEMP			= $00	;3 bytes in zeropage used by the library as a scratchpad
; FT_DPCM_OFF		= $c000	;$c000..$ffc0, 64-byte steps
; FT_SFX_STREAMS	= 4		;number of sound effects played at once, 1..4

; FT_DPCM_ENABLE			;undefine to exclude all DMC code
; FT_SFX_ENABLE			;undefine to exclude all sound effects code
; FT_THREAD				;undefine if you are calling sound effects from the same thread as the sound update call

; FT_PAL_SUPPORT			;undefine to exclude PAL support
; FT_NTSC_SUPPORT			;undefine to exclude NTSC support



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

enemyX:                 .res 4 ; 000b - 000e
enemyY:                 .res 4 ; 000f - 0002

enemyH:                 .res 1
enemyW:                 .res 1 ; 0014
enemyMode:				.res 1 
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

masterTimer:				.res 1      ; 002B
animationTimer:				.res 1		; 002C
frameTimer:					.res 1      ; 002D

consoleLog:					.res 1  ; 002E

gameStateIsPowered: 		.res 1 ; 002F

; Wish I knew why I can't use the stack for this
tempX:					.res 1 ; 0030
tempY:					.res 1 ; 0031

; if these don't move, why do I need these in RAM?
; powerUpX:				.res 1 ; 0030 ;; if these don't move we can read them from ROM
; powerUpX2:				.res 1
; powerUpX3:				.res 1
; powerUpX4:				.res 1
; powerUpY:				.res 1	; 0034 ;; then loop through the locations, though I'd have to remember which ones are "gone"
; powerUpY2:				.res 1
; powerUpY3:				.res 1
; powerUpY4:				.res 1
powerUpAvailable:		.res 1 ; 0038 one byte ;; 7654321 - bit one is if the the first one is available
; this might control which powerUp has to be used next
powerUpTimer:			.res 1 ; 0039

bufferBackgroundColor:	.res 1 ; 003A
bufferBackgroundValLo:	.res 1
bufferBackgroundValHi:	.res 1

dotsLeft:				.res 1	;003D
inning:					.res 1

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

enemyState:				.res 4

enemyXWork:						.res 1
enemyYWork:						.res 1

enemyCMPTemp:					.res 1
enemyAbsX:						.res 1
enemyAbsY:						.res 1
sqIn:							.res 1
sqX:							.res 2
sqY:							.res 2
sumXY:							.res 2

enemyDistance:					.res 6
enemyDirectionArray:			.res 3

sqOut:							.res 2


enemyTempForLoop:				.res 1
enemyDirectionIndex:			.res 1 ; 007B ; these are probably bad
enemyBufferDirectionCurrent:	.res 1 ; 007C

bufferBackgroundTile:			.res 1 ; 007D
collisionBackgroundTile:		.res 1 ; 007E
controlTimer:					.res 1 ; 007F

playerGridXAI:					.res 1 ; 0080
playerGridYAI:					.res 1 ; 0081

gamePaused:						.res 1 ; 0086 ; these are right
PPUState:						.res 1 ; 0087
PPUState2:						.res 1 ; 0088
gamePlayerReset:				.res 1 ; 0089
gameOuts:						.res 1 ; 008a

scoreLo:						.res 1 ; 008b
vram_lo:						.res 1 ; 008c
vram_hi:						.res 1 ; 008d

scoreDigit0:			.res 1 ; 008e
scoreDigit1:			.res 1 ; 008f
scoreDigit2:			.res 1 ; 0090
scoreDigit3:			.res 1 ; 0091
scoreDigit4:			.res 1
scoreDigit5:			.res 1
scoreDigit6:			.res 1
scoreDigit7:			.res 1
scoreDigit8:			.res 1
scoreDigit9:			.res 1
scoreDigit10:			.res 1
scoreDigit11:			.res 1
scoreDigitBuffer:		.res 1
scoreValue:				.res 1

inningDigit0:			.res 1 ; 0096?
inningDigit1:			.res 1
inningDigit2:			.res 1

tempX1:					.res 1


; NES-defined RAM locations
PPU_CTRL_REG1         	= $2000
PPU_CTRL_REG2         	= $2001
PPU_STATUS            	= $2002
PPU_SPR_ADDR          	= $2003
PPU_SPR_DATA          	= $2004
PPU_SCROLL_REG       	= $2005
PPU_ADDRESS           	= $2006
PPU_DATA         		= $2007

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

.segment "RAM"
nametable_buffer:		.res $3C0 	; 960 blocks
vram_buffer_offset:		.res $01	; 1 byte offset $06C2
vram_buffer:			.res $40	; 32 		   +$0040 = $0702



; BASE CORDINATES -- HARD CODED 
.segment "CODE"
powerUpX:
.byte $E8, $80, $10, $80
powerUpY:
.byte $60, $10, $60, $D0

