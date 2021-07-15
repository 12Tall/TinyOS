01_mbr:01_mbr.*
	nasm -o mbr.bin 01_mbr.asm

01_read_hdd:01_read_hdd.*  
	nasm -o mbr.bin 01_read_hdd.asm

debug:
	dd if=mbr.bin of=/home/doumiao2/bochs/hd60.img bs=512 count=1 conv=notrunc
	/home/doumiao2/bochs/bin/bochs -f /home/doumiao2/bochs/bochsrc.disk