%include "mbr.inc"

[bits 16]
section mbr vstart=0x7c00 align=16  ; vstart 只会影响程序跳转
mov ax, cs                      ;
mov ds, ax
mov es, ax
mov fs, ax
mov ax, Seg_ColorText           ; 初始化各类段寄存器
mov gs, ax           ; 初始化各类段寄存器
; mov ds: 0x0b00 ; 不能为段寄存器赋立即数
jmp start

; 函数本身不会修改段寄存器信息
; ---------- 打印字符串 ----------
; push 字符串地址
; push 字符串长度
printStr:                       ; 函数负责维护堆栈及调用上下文
push bp                         ; 保存原有栈指针
mov bp, sp                      ; 保存栈顶指针用于寻找变量，
; [bp]=bp,[bp+2]=ip             ; 需要注意的是函数调用时会自动push ip
mov ax, Seg_ColorText
mov gs, ax                      ; 显存，彩色文本
mov si, [bp+6]                  ; 字符串起始指针
mov cx, [bp+4]                  ; 字符串长度
mov di, 0x00
; mov ah, 0x07                    ; 字符样式，包括颜色、亮度、闪烁等

.loop:                          ; 局部标签以`.` 开头，表示属于前一个非局部标签
mov byte al, [si]               ; 言下之意，局部标签之前必须要有一个非局部标签
mov byte [gs:di], al            ; 给内存赋值要加限定符
add di, 2
add si, 1
sub cx, 1
jnz .loop                       ; 局部标签用在函数内跳转比较有用

pop bp
ret 

; ---------- 读取硬盘数据 ----------
; push dword 起始扇区                  ; 24 位，索性我们传入32 位
; push 扇区个数
; push 目标内存地址  
readHdd:
push bp
mov bp, sp

; mov ax, [bp+8]                       ; LBA 低16 位
; mov bx, [bp+10]                      ; LBA 高8 位
; mov cx, [bp+6]                       ; 要读取的字节数
; mov di, [bp+4]                       ; 目标内存地址

; 要读取的扇区个数  
xor dx, dx                             ; 除法注意给dx 清零
mov ax, [bp+6]
mov bx, 512
div bx                                 ; 商在ax，余数在dx
cmp dx, 0  
jz .a512
inc ax                                 ; 多读取一个扇区
.a512:                                 ; 刚好是整数扇区
mov dx, HDD_SECT_NUM_PORT
out dx, al                             ; 一个端口只能写入8 位数据

; 要读取的起始扇区                       ； 这里可以重复利用ax
mov ax, [bp+8]       
mov dx, HDD_ADDR_PORT                  ; 8
out dx, al
inc dx                                 ; 16
shr ax, 8
out dx, al
mov ax, [bp+10]
inc dx                                 ; 24
out dx, al
inc dx                                 ; 28
or ah, HDD_LBA                         ; 1110 xxxx
shr ax, 8
out dx, al

; 写入读命令  
mov ax, HDD_READ  
mov dx, HDD_CMD_PORT  
out dx, al                             ; 写入读命令

.wait:                                 ; 等待硬盘就绪
; mov dx, HDD_STATUS_PORT
in al, dx                              ; 读取硬盘状态
and al, HDD_STATUS_AVAILABLE                       ; 
cmp al, HDD_STATUS_READY
jnz .wait

; 读取数据
mov di, [bp+4]
mov ax, [bp+6]
mov dx, 0x00
mov bx, 2
div bx
push dx                               ; 如果小于一个字，则最多读取一个字节
mov dx, HDD_DATA_PORT                 ; 设置数据端口
cmp ax, 0
jz .read_byte

mov cx, ax
.read_words:  
in ax, dx                              ; 读取一个字
mov word [di], ax                      ; 保存至内存
add di, 2
dec cx
jnz .read_words

.read_byte:
pop ax 
cmp ax, 0
jz .return
in ax, dx                          ; 读取一个字
mov byte [di], al                      ; 保存至内存

.return:
pop bp
ret

start:
push dword 0x09                   ; 从第一个扇区开始，
push word 10240                    ; 拷贝513 个字符
push word loader                ; 到hdd_data 位置
call readHdd
sub esp, 8


jmp loader

push word hdd_data                ; 传递字符串地址
push word 513                     ; 传递字符串长度
call printStr  
sub esp, 4                        ; 平衡堆栈

jmp $


message db "hello world!"
len     db 12

times 510-($-$$) db 0           ; 在真机上运行时，需要在mbr 区域添加磁盘分区信息
                 db 0x55, 0xaa

hdd_data:                       ; 预留两个扇区
resb 1024

loader equ 0x900