CFLAGS = -Wall -pedantic -W -nostdlib -nostdinc -Wno-long-long -fomit-frame-pointer -m32

all:barras.img

bootsect.o:bootsect.asm
	nasm -f elf -o $@ $<
	
loader.o:loader.asm
	nasm -f elf -o $@ $<
	
kernel.o:kernel.asm
	nasm -f elf -o $@ $<

barras.img:bootsect loader kernel
	cat bootsect loader kernel > barras.img
	
bootsect:bootsect.o
	ld -m elf_i386 --oformat binary -N -e boot -Ttext 0x7c00 -o bootsect $<
	
loader:loader.o
	ld -m elf_i386 --oformat binary -N -e pm_mode -Ttext 0x8000 -o loader $<
	
kernel:kernel.o init.o
	ld -m elf_i386 --oformat binary -N -e start -Ttext 0x6000 -o kernel kernel.o init.o
	
*.o:*.c
	gcc $(CFLAGS) -Os -c -o $@ $<
clean:
	rm -f *.img bootsect loader *.o
