; MBR 
; 读取硬盘数据   

%include "01_read_hdd.inc"

section MBR vstart=0x7c00
  mov ax, cs  
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov fs, ax  
  mov sp, 0x7c00  
  mov ax, 0xb800              ; 显存
  mov gs, ax

; 清屏  
mov ax, 0x0600
mov bx, 0x0700  
mov cx, 0x00
mov dx, 0x184f  
int 0x10  

; 打印字符串  
mov byte [gs:0x00], '1'
mov byte [gs:0x01], 0xa4  
mov byte [gs:0x02], ' '
mov byte [gs:0x03], 0xa4  
mov byte [gs:0x04], 'M'
mov byte [gs:0x05], 0xa4  
mov byte [gs:0x06], 'B'
mov byte [gs:0x07], 0xa4  
mov byte [gs:0x08], 'R'
mov byte [gs:0x09], 0xa4  

mov eax, LOADER_START_SECTOR   ; 起始扇区的lba 地址
mov bx, LOADER_BASE_ADDR       ; 写入的地址
mov cx, 0x01                   ; 扇区数  
call read_disk_m_16  

jmp LOADER_BASE_ADDR           ; 加载完之后跳转执行读取的数据  

; 读取n 个扇区  
read_disk_m_16:                ; eax=扇区号，cx=扇区数量，bx=待写入的内存地址
    mov esi, eax               ;
    mov di, cx                 ; 备份数据

; 设置要读取的扇区数  
    mov dx, 0x01f2
    mov al, cl  
    out dx, al                 ; 向0x01f2 号端口写入要读取的扇区数

; 设置要读取的lba 地址  
    mov eax, esi
    mov dx, 0x01f3             ; 0-7 
    out dx, al  

    mov cl, 0x08               ; 8-15
    shr eax, cl  
    mov dx, 0x01f4
    out dx, al  

    shr eax, cl                ; 16-23
    mov dx, 0x01f5
    out dx, al  

    shr eax, cl                ; 24-32
    and al, 0x0f               ; 为啥到这里就要and 一下呢
    or al, 0xe0                ; 设置7~4 位为1110，表示lba 模式
    mov dx, 0x01f6
    out dx, al  

; 读取
    mov dx, 0x01f7
    mov al, 0x20  
    out dx, al  
.not_ready:  
    nop 
    in al, dx  
    and al, 0x88               ; 第4位表示就绪，第7位表示硬盘忙
    cmp al, 0x08  
    jnz .not_ready

; 从0x01f0 端口读取数据  
    mov ax, di                 ; 读取的扇区数
    mov dx, 256                ; 每次读取一个字，也就是两个字节
    mul dx  
    mov cx, ax  
    mov dx, 0x01f0
.go_on_read:
    in ax, dx  
    mov [bx], ax  
    add bx, 0x02  
    loop .go_on_read           ; 调试loop 指令也需要用s：step into
    ret  

message db "My MBR"            ; 数据和代码最好不要混在一块儿

times 510-($-$$) db 0
db 0x55,0xaa

