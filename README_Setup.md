# My Development Setup

Assembler: CA65
- Install instructions: http://wiki.nesdev.com/w/index.php/Installing_CC65

OS: macOS Catalina 10.15.6
Editor: VS Code 
- using ca65 Macro Assembler Language Support (6502/65816) extension
- Also used LaserWave theming to get into the RetroWave mindset.
Assembler: CA65 (part of CC65)
- CC65 is a “C compiler for 6502 targets”
- I used just the macro assembler and link utility part of the package.
Primary Emulator/Debugger: Nintaco
	Out of the emulators that I tried, Nintaco came the closest to original hardware for me.  It was also really the only emulator with robust debugging features that I could find.

Release Targets: NES (original hardware through a flash cart), JSNES
	Making a game work on the original hardware, the NES, was my ultimate goal of this project.  The JSNES emulator was a deliverable so we could share the playable game on FanGraphs.

I would develop primarily on Nintaco, because of the debugging features, but I would have to periodically check the builds on the release targets, because there were bugs specific to each platform.  For example, Nintaco would zero-out the RAM pretty well, but the NES did not, so the NES had random sprites on the screen when I started the game.

Flash Cart: Everdrive N8
	Expensive, but quicker than flashing EPROM to get the game on the original hardware.

## Support Software

Graphics: TM (has a terrible full name)
- Also used this shell script to fill out a 8kb binary of 0s for a blank .chr file.
- This was good to edit the binary .chr file by using a “paint-type” interface.

Music/SFX: FamiStudio
- New program that provides easy, quick tools to create NES sound. It has a great video tutorial. I only wish I was more musical.

## Scripts
```
./makeGame
```

I created an executable shell script to assemble the code and write out the ROM.


## Watch Files

In Nintaco, I created several RAM watch files that I used to debug the game.  The files changed as I changed RAM allocation during development.


```
STA consoleLog
```

I come from Front End Web Dev, so I need my console.log. Having a byte of RAM dedicated to this so I could dump registers or variables at certain times was very helpful.


