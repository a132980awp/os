; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;=========================================================================
;					void _run();
;=========================================================================
;加载并运行程序
public _run
_run proc	
	push es
	xor ax,ax
	mov es,ax
	push word ptr es:[9*4]                  ; 保存 9h 中断
	pop word ptr ds:[0]
	push word ptr es:[9*4+2]
	pop word ptr ds:[2]

	mov word ptr es:[24h],offset keyDo		; 设置键盘中断向量的偏移地址
	mov ax,cs 
	mov word ptr es:[26h],ax
	
	
	mov ax,cs
	mov es,ax 		                ;设置段地址, 存放数据的内存基地址
	mov bx,0B100h				; ES:BX=读入数据到内存中的存储地址
	mov ah,2 		                ; 功能号
	mov al,1 	                	; 要读入的扇区数 1
	mov dl,0                 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
	mov dh,0 		                ; 磁头号
	mov ch,0                 		; 柱面号
	mov cl,byte ptr[_pro]          	; 起始扇区号（编号从1开始）
	int 13H 		                ; 调用13H号中断
	
	mov bx, 0B100h
	call bx                    ; 跳转到该内存地址
	
	xor ax,ax
	mov es,AX
	push word ptr ds:[0]                     ; 恢复 9h 中断
	pop word ptr es:[9*4]
	push word ptr ds:[2]
	pop word ptr es:[9*4+2]
	int 9h
	pop es
_run endp


;****************************
; void _cls()               *
;****************************
public _cls
_cls proc 
; 清屏
        push ax
        push bx
        push cx
        push dx		
			mov	ax, 600h	; AH = 6,  AL = 0
			mov	bx, 700h	; 黑底白字(BL = 7)
			mov	cx, 0		; 左上角: (0, 0)
			mov	dx, 184fh	; 右下角: (24, 79)
			int	10h		; 显示中断
			
			mov ah, 02h
			mov bh, 0
			mov dx, 0000h
			int 10h
		pop dx
		pop cx
		pop bx
		pop ax
		ret
_cls endp


;********************************************************
; void _printChar(char ch)                            *
;********************************************************
public _printChar
_printChar proc 
	push bp
		mov bp,sp
		mov al,[bp+4]
		mov bl,0
		mov ah,0eh
		int 10h
		mov sp,bp
	pop bp
	ret
_printChar endp


;****************************
; void _getChar()           *
;****************************

public _getChar
_getChar proc
	mov ah,0
	int 16h
	mov byte ptr [_input], al
	ret
_getChar endp

;*************** ********************
;*  void _int33()                       *
;**************** *******************
; 调用 33h 
public _Int33
_Int33 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

    int 33h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_Int33 endp

;*************** ********************
;*  void _int34()                       *
;**************** *******************
; 调用 34h
public _Int34
_Int34 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

    int 34h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_Int34 endp

;*************** ********************
;*  void _int35()                       *
;**************** *******************
; 调用 35h
public _Int35
_Int35 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

    int 35h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_Int35 endp

;*************** ********************
;*  void _int36()                       *
;**************** *******************
; 调用 36h
public _Int36
_Int36 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

    int 36h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_Int36 endp
