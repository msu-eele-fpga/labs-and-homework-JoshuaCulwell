ifneq ($(KERNELRELEASE),)
obj-m := hello_world_kernel.o

else

KDIR ?= linux-socfpga
default:
	$(MAKE) -C $(KDIR) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

endif
