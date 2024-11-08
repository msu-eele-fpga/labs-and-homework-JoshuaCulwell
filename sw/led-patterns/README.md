## This is the README for led-patterns.

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
