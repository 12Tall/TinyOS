%include "mbr.inc"
%include "proc.inc"
%include "pm_desc.inc"

bits 16
section loader vstart=loader_base
jmp loader_start

GDT_BASE: dq 0x00      ; 第一个gdt 项，总是不可用  
; 系统代码段，起始0x00，界限0xfffff
GDT_CODE: 
SegmentDescriptor 0x00, 0xfffff, (Desc_G_4K|Desc_D_32|Desc_P|Desc_DPL0|Desc_SYS|Desc_CODE_X)

; 数据段
GDT_STACK: 
SegmentDescriptor 0x00, 0xfffff, (Desc_G_4K|Desc_D_32|Desc_P|Desc_DPL0|Desc_SYS|Desc_STACK_R)


; 视频数据段
GDT_VIDEO: 
SegmentDescriptor 0xb8000, 0x07, (Desc_G_4K|Desc_D_32|Desc_P|Desc_DPL0|Desc_SYS|Desc_STACK_R)


GDT_SIZE equ $-GDT_BASE
GDT_LIMIT equ GDT_SIZE-1
times 60 dq 0          ; 预留60个描述符
Selector_Code equ SegmentSelector(1, TI_GDT+RPL0)
Selector_Stack equ SegmentSelector(2, TI_GDT+RPL0)
Selector_Video equ SegmentSelector(3, TI_GDT+RPL0)

gdt_ptr dw GDT_LIMIT
        dd GDT_BASE  

loadermsg db '2 loader in real'

loader_start:
;打印字符，"2 LOADER"说明loader已经成功加载
; 输出背景色绿色，前景色红色，并且跳动的字符串"1 MBR"
mov byte [gs:160],'2'
mov byte [gs:161],0xA4     ; A表示绿色背景闪烁，4表示前景色为红色

mov byte [gs:162],' '
mov byte [gs:163],0xA4

mov byte [gs:164],'L'
mov byte [gs:165],0xA4   

mov byte [gs:166],'O'
mov byte [gs:167],0xA4

mov byte [gs:168],'A'
mov byte [gs:169],0xA4

mov byte [gs:170],'D'
mov byte [gs:171],0xA4

mov byte [gs:172],'E'
mov byte [gs:173],0xA4

mov byte [gs:174],'R'
mov byte [gs:175],0xA4

; jmp $

in al, 0x92   ; 打开a20
or al, 0x02  
out 0x92, al

lgdt [gdt_ptr] ; 装载gdt

mov eax, cr0  ; 开启pe 位  
or eax, 0x01  
mov cr0, eax

jmp Selector_Code:p_mode_start  ; 刷新流水线

[bits 32]         ; 保护模式下的代码
p_mode_start:
   mov ax, Selector_Stack
   mov ds, ax
   mov es, ax
   mov ss, ax
   mov esp,loader_base
   mov ax, Selector_Video
   mov gs, ax

   mov byte [gs:180], 'P'
   mov byte [gs:181], 0xA4

   jmp $
