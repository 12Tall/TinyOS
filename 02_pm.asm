%include "SegmentDescriptor.inc"
SegmentDescriptor 0x00000000, 0xfffff, (Desc_G_4K|Desc_D_32|Desc_P|Desc_DPL0|Desc_SYS|Desc_CODE_XC)

; dd 1100_1001_1010B 
; dd (Desc_G_4K|Desc_D_32|Desc_P|Desc_DPL0|Desc_SYS|Desc_CODE_XC)