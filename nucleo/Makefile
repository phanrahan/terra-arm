ARMGNU = arm-none-eabi

ASFLAGS = --warn --fatal-warnings -mcpu=cortex-m0

all : blinker01.bin 

clean:
	rm -f *.bin
	rm -f *.elf
	rm -f *.o
	rm -f *.list

#---------------------------------

flash.o : flash.s
	$(ARMGNU)-as $(ASFLAGS) flash.s -o flash.o

blinker01.o : blinker01.t
	terra blinker01.t blinker01.o

blinker01.bin : flash.ld flash.o blinker01.o
	$(ARMGNU)-ld -o blinker01.elf -T flash.ld flash.o blinker01.o
	$(ARMGNU)-objdump -D blinker01.elf > blinker01.list
	$(ARMGNU)-objcopy blinker01.elf blinker01.bin -O binary




