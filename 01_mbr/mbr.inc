; 实模式下的段定义
; loader 被加载的入口地址
loader_base equ 0x900

; 常用段基址
Seg_ColorText equ 0x0b800


; 硬盘操作相关
HDD_READ equ 0x20  
HDD_WRITE equ 0x30
HDD_STATUS_AVAILABLE equ 0x88
HDD_STATUS_READY equ 0x08
HDD_LBA equ 0xe0
HDD_DATA_PORT equ 0x1f0
HDD_INFO_PORT equ 0x1f1
HDD_SECT_NUM_PORT  equ 0x1f2
HDD_ADDR_PORT  equ 0x1f3
HDD_CMD_PORT  equ 0x1f7
HDD_STATUS_PORT  equ 0x1f7
