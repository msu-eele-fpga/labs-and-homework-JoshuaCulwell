# Lab 8 - led_patterns.c

## Overview
This lab is to demonstrate creating led patterns from the command line interface for the FPGA. 
A C program was written that can be called from the command line with the flags -p for pattern, -f for file, and -v for verbose.
There is also a -h flag for more in depth description.

The program writes a pattern to the LEDs then waits for its respective duration before writing the next pattern or looping the patterns.

### Deliverables
[link to led-patterns](https://github.com/msu-eele-fpga/labs-and-homework-JoshuaCulwell/blob/main/sw/led-patterns/README.md)

How I calculated the physical addresses of my components registers:
- First was the offset given in the lab-7 modified instructions: 0xff200000
- The registers are offset by 4 bytes of memory each.
- The register that puts it into hps hardware control is the third register at an offset of 8 bytes so: 0xff200008
- The register that writes to the leds is the second register at an offset of 4 bytes so: 0xff200004
