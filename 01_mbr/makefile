build: mbr.asm mbr.inc
	nasm mbr.asm -o mbr.bin -l mbr.lst
	dd if=mbr.bin of=/home/doumiao2/bochs/hd60.img bs=512 count=1 conv=notrunc
	/home/doumiao2/bochs/bin/bochs -f /home/doumiao2/bochs/bochsrc.disk