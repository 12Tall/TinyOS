# TinyOS
x86 操作系统学习。爲啥vscode 會自動將簡體中文變成繁體？？？  

## Bochs  
Install and Configurate `Bochs`. see [bochs环境配置](https://zhuanlan.zhihu.com/p/35437842). What we should pay attention to is don't mix None-ASCII code in configuration file.  

## Memory Distribution in Real Mode    

80386 has 1MB memory, and 16bits address instruction.
Start|End|Size|Usage  
---|---|---|---  
f fff0|f ffff|16B|BIOS 入口，系統加電後自動將IP 定位到此處。`jmp f000:e05b`  
f 0000|f ffef|64KB-16B|