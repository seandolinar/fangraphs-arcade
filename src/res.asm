
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

