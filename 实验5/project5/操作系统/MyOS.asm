extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

;导入C中的全局函数或全局变量,本例中导入了3个
;extern _cmain:near  ;导入C中的主函数main()
extern _pro:near
extern _input:near
extern _cmain:near
extern _to_date:near
extern _to_time:near
extern _to_picture:near

extrn _ch1:near            ; C 中变量，存放临时字符
extrn _ch2:near            ; C 中变量，存放临时字符
extrn _ch3:near            ; C 中变量，存放临时字符
extrn _ch4:near            ; C 中变量，存放临时字符
extrn _t:near             ; C 中的变量，用于存储读入的字符

;服务程序
extern _to_upper:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h

start:

	;设置 21h 的中断
	xor ax,ax
	mov es,ax
	mov word ptr es:[33*4],offset SERVER		; 设置 21h 的偏移地址
	mov ax,cs 
	mov word ptr es:[33*4+2],ax

	;设置 20h 时间中断
    xor ax,ax				        		        ; AX = 0
	mov es,ax					                    ; ES = 0
	mov ax,offset Timer
	mov word ptr es:[20h],offset Timer		        ; 设置时钟中断向量的偏移地址
	mov ax,cs 
	mov word ptr es:[22h],cs				        ; 设置时钟中断向量的段地址=CS
	
	;设置 33h 的中断
	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset BIOSService_1		; 设置 33h 的偏移地址
	mov ax,cs 
	mov word ptr es:[51*4+2],ax

	;设置 34h 的中断
	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset BIOSService_2		; 设置 34h 的偏移地址
	mov ax,cs 
	mov word ptr es:[52*4+2],ax

	;设置 35h 的中断
	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset BIOSService_3		; 设置 35h 的偏移地址
	mov ax,cs 
	mov word ptr es:[53*4+2],ax

	;设置 36h 的中断
	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset BIOSService_4		; 设置 36h 的偏移地址
	mov ax,cs 
	mov word ptr es:[54*4+2],ax

		mov ax,cs;准备设置有关的段寄存器
		mov ds,ax; DS = CS
		mov es,ax; ES = CS
		mov ss,ax; SS = cs
		mov sp, 0FFF0h ;栈顶在段内高端，留空了16单元
		mov ah, 02h
		mov bh, 0
		mov dx, 0000h
		int 10h
		call near ptr _cmain
;汇编预处理安排在这里
    	jmp $	
;利用包含伪指令，将一些内核汇编语言过程文件纳入本程序，如本例中kliba.asm文件		
		include kliba.asm
		include services.asm
		include clib.asm

_TEXT ends

_DATA segment word public 'DATA'

_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start