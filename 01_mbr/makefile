mbr: mbr.asm mbr.inc
	nasm mbr.asm -o mbr.bin -l mbr.lst
	dd if=mbr.bin of=/home/doumiao2/bochs/hd60.img bs=512 count=1 conv=notrunc
	/home/doumiao2/bochs/bin/bochs -f /home/doumiao2/bochs/bochsrc.disk

proc: proc.asm
	nasm proc.asm -o proc.bin -l proc.lst
	dd if=proc.bin of=/home/doumiao2/bochs/hd60.img bs=512 seek=9 count=3 conv=notrunc
# skip 可以跳过第n个bs 大小的块