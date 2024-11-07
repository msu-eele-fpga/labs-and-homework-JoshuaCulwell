# Lab 8 - led_patterns.c

## Overview
This lab is to demonstrate creating led patterns from the command line interface for the FPGA. 
A C program was written that can be called from the command line with the flags -p for pattern, -f for file, and -v for verbose.
There is also a -h flag for more in depth description.

The program writes a pattern to the LEDs then waits for its respective duration before writing the next pattern or looping the patterns.

## Deliverables
### NOTE:
You MUST have the FPGA fabric programmed with the soc_system.rbf OR the de10nano Quartus project prior to using led_patterns.
### Usage:
![usage_text](assets/usage_text.jpg)

### How to compile:
1. Type the following command while in the directory of led_patterns.c: ```arm-linux-gnueabihf-gcc -o led_patterns -Wall -static led_patterns.c```
2. Compilation done.
3. If it is found you do not have access to that command execute the command: ```sudo apt install gcc-arm-linux-gnueabihf``` then repeat step 1.

### Extra deliverables
[link to led-patterns](https://github.com/msu-eele-fpga/labs-and-homework-JoshuaCulwell/blob/main/sw/led-patterns/README.md)

How I calculated the physical addresses of my components registers:
- First was the offset given in the lab-7 modified instructions: 0xff200000
- The registers are offset by 4 bytes of memory each.
- The register that puts it into hps hardware control is the third register at an offset of 8 bytes so: 0xff200008
- The register that writes to the leds is the second register at an offset of 4 bytes so: 0xff200004