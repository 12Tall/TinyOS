# TinyOS
x86 操作系统学习。  

## Bochs  
Install and Configurate `Bochs`. see [bochs环境配置](https://zhuanlan.zhihu.com/p/35437842). What we should pay attention to is don't mix None-ASCII code in configuration file.  

## Memory Distribution in Real Mode    

80386 has 1MB memory, and 16bits address instruction.
Start|End|Size|Usage  
---|---|---|---  
f fff0|f ffff|16B|BIOS 入口，系统上电后自动定位到此处。`jmp f000:e05b`  
f 0000|f ffef|64KB-16B|系统BIOS（目测就是BIOS 代码段）  
c 8000|e ffff|160KB|映射硬件适配器的ROM 或者内存映射式的I/O  
c 0000|c 7fff|32KB|显示适配器的BIOS  
b 8000|b ffff|32KB|用于文本模式显示适配器  
b 0000|b 7fff|32KB|用于黑白显示适配器  
a 0000|a ffff|64KB|用于彩色显示适配器  
9 fc00|9 ffff|1KB|EBDA 扩展BIOS 数据区  
0 7e00|9 fbff|622080B|可用区域  
0 7c00|0 7dff|512B|MBR 主引导  
0 0500|0 7bff|30464B|可用区域  
0 0400|0 04ff|256B|BIOS 数据区  
0 0000|0 03ff|1KB|中断向量表  

### 为啥是0x7c00  
1. 硬盘中的扇区大小为512B。0盘0道第一个扇区；  
2. `jmp 0:0x7c00` 绝对远转移（段间转移）会重新设置`CS`，这里是`0`；  

**历史原因**  
IBM PC 5150。开机自检后会调用Int 19h，如果检测到可用磁盘，就会将它的第一个扇区加载到`0x7c00`。而此版本的BIOS 默认内存最小值是32KB，也即是`0x8 0000`。参照上表，为了不让MBR 被其他数据所覆盖，所以放置在32KB 的末尾。而MBR 本身要用到栈，所以共分配了1KB 的空间。所以`0x8 0000 - 0x0 0400 = 0x0 7c00`。这就是该地址的由来。[-- 操作系统真相还原(https://book.douban.com/subject/26745156/)



