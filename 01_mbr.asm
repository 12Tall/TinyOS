; Master Boot Record 
; 主引导记录  

section MBR vstart=0x7c00  ; 程序入口  
mov ax, cs                 ; cs 被初始化为0
mov ds, ax                 ; 也就是将各寄存器都设置为0  
mov es, ax  
mov ss, ax  
mov fs, ax  
mov sp, 0x7c00             ; push：递减sp，然后将数据放入[ss:sp]
                           ; 相当于先sub esp, n 再mov [esp], x

; 清理屏幕。利用int10 的0x06 号任务  
; https://zh.wikipedia.org/wiki/INT_10H
; 类似于clear(bgcolor, top, left, bottom, right)
mov ax, 0x0600             ; mov ah, 0x06
mov bx, 0x0700             ; 设置背景色
mov cx, 0                  ; 设置高行数，左列数
mov dx, 0x184f             ; 
int 0x10


; 获取光标位置  
mov ah, 3                  ; int 10 的三号子功能
mov bh, 1                  ; 页码  
int 0x10  


; 打印字符串  
mov ax, message  
mov bp, ax  

mov cx, 6                  ; 字符串长度，不包含'\0'
mov ax, 0x1301
mov bx, 0x02  
int 0x10  

jmp $                      ; 跳转到本行，死循环  

message db "My MBR"  
times 510-($-$$) db 0  
db 0x55, 0xaa