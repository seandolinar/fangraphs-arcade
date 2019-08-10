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
oam: .res 256        ; sprite OAM data to be uploaded by DMA
					 ; .res reserves 256 bytes of storage


.segment "ZEROPAGE"
playerLocationX: .res 1
playerLocationY: .res 1
controllerBits: .res 1


