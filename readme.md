# Summary

This is an NES 6502 assembly project coded to use the ca65 assembler.

The `.nes` file is built game ROM and should work on any NES emulator or hardware.


# Setup

## [My Development Evironment](./README_Setup.md)

## Build
To build the ROM file:

```
./makeGame
```

That bash script contains the assembler and the linker commands.

The ca65 assembler is part of the cc65 package and install instructions can be found here: http://wiki.nesdev.com/w/index.php/Installing_CC65


# Music / Sound

[Famistudio](https://famistudio.org/)
Famistudio was used to create music and sound effects for the game.  The music and sound effects were exported using the respective Famitone2 export options.

[Famitone2](https://shiru.untergrund.net/code.shtml)
The Famitone2 library was used to played the exported music and sound effects.

