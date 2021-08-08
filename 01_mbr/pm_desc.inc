
; 段属性  
Desc_G_4K equ 1000_0000_0000b ; 粒度  
Desc_D_32 equ 0100_0000_0000b ; 数据段，有效地址操作数是32 位
Desc_B_32 equ 0100_0000_0000b ; 堆栈段的栈指针寄存器是32 位
Desc_L    equ 0010_0000_0000b ; 是否为64 位代码段，保持为0 即可
Desc_AVL  equ 0001_0000_0000b ; 软件可用位，处理器不使用此位
Desc_P    equ 0000_1000_0000b ; 段位于内存中
Desc_DPL0 equ 0000_0000_0000b ; 特权级0
Desc_DPL1 equ 0000_0010_0000b ; 特权级1
Desc_DPL2 equ 0000_0100_0000b ; 特权级2
Desc_DPL3 equ 0000_0110_0000b ; 特权级3
; 系统段，主要包括LDT、TSS以及各种调用门等
Desc_SYS  equ 0000_0001_0000b ; 未定义
Desc_LDT  equ 0000_0001_0010b ; 
Desc_386_TSS_AVL   equ 0000_0001_1001b ; 
Desc_386_TSS_INV   equ 0000_0001_1011b ; 
Desc_386_CALL_GATE equ 0000_0001_1100b ; 
Desc_386_INT_GATE  equ 0000_0001_1110b ; 
Desc_386_TRAP_GATE equ 0000_0001_1111b ; 
; 非系统段，处理器在加载过此段时会将最后一位置一。
Desc_NONE_SYS  equ 0000_0000_0000b ; 
Desc_CODE_X    equ 0000_0000_1000b ; 
Desc_CODE_XR   equ 0000_0000_1100b ; 
Desc_CODE_XC   equ 0000_0000_1010b ; 
Desc_CODE_XRC  equ 0000_0000_1110b ; 
Desc_DATA_R    equ 0000_0000_0000b ; 
Desc_DATA_RW   equ 0000_0000_0100b ; 
Desc_STACK_R   equ 0000_0000_0010b ; 向下扩展，位栈段
Desc_STACK_RW  equ 0000_0000_0110b ; 

%macro SegmentDescriptor 3  ; 段基址-段界限-段属性：32-20-12
dw %2 & 0xffff
dw %1 & 0xffff
db (%1 >> 16) & 0xff
db (%3) &0xff
db ((%2 >> 16) & 0x0f) | ((%3 >> 4) & 0xf0)
db (%1 >> 24) & 0xff
%endmacro

; 段选择子属性 
;--------------   选择子属性  ---------------
RPL0  equ   00b
RPL1  equ   01b
RPL2  equ   10b
RPL3  equ   11b
TI_GDT	 equ   000b
TI_LDT	 equ   100b
%define SegmentSelector(index, attr) (index<<3)+attr