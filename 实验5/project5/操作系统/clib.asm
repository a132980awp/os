; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              clib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;*************** ********************
;*  void _to_OUCH()                       *
;**************** *******************
; 调用 21h 0号功能
public _to_OUCH
_to_OUCH proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

	mov ah,0
    int 21h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_to_OUCH endp

;*************** ********************
;*  void _upper()                       *
;**************** *******************
; 调用 21h 1号功能 
public _upper
_upper proc 
    push bp
	mov	bp,sp
	push si
	mov	si,word ptr [bp+4]           ; 获得字符串首地址

    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,1
	mov dx,si                        ; 把字符串首地址给 dx 
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax

	pop si
	pop bp
	ret
_upper endp

;*************** ********************
;*  void _to_date()                       *
;**************** *******************
; 调用 21h 2号功能
public _date
_date proc 
    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,2
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_date endp

;*************** ********************
;*  void _time()                       *
;**************** *******************
; 调用 21h 3号功能
public _time
_time proc 
    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,3
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_time endp

;*************** ********************
;*  void _picture()                       *
;**************** *******************
; 调用 21h 4号功能
public _picture
_picture proc 
    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,4
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_picture endp