# Lab 11: Platform Device Drivers

## Overview
In this lab we created a kernel module that creates drivers for the led patterns FPGA component.

### Questions 
> What is the purpose of the platform bus?

The platform bus is a virtual bus which is used to connect different devices to the kernel

> Why is the device driver's compatible property important?

The compatible property is important because it tells the device tree which driver to use.

> What is the ```probe``` function's purpose?

The ```probe``` function is used to "search" for devices and initialize them if found when the module is added.

> How does your driver know what memory addresses are associated with your device?

The driver knows what memory addresses are associated with the device because in the device tree for that device the address and span are instanciated.

> What are the two ways we can write our device's registers? In other words, what subsystems do we use to write to our registers?

The two ways to write to our device's registers are using the ```misc subsystem``` or by writing values to the appropriate location in the ```/dev/led_patterns``` file. 

> What is the purpose of our struct ```led_patterns_dev``` state container?

The purpose of the ```led_patterns_dev``` struct is to hold information necessary for each subsystem so that the functions in the kernel driver can use them. 
