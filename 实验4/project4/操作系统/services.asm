; 本程序为 6 个系统服务程序

Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es

	dec byte ptr es:[count]				; 递减计数变量
	jnz End1						    ; >0：跳转
	inc byte ptr es:[bn]                ; 自增变量 bn
	cmp byte ptr es:[bn],1              ; 根据 bn 选择跳转地址，1 则显示 /
	jz ch1
	cmp byte ptr es:[bn],2              ; 2 则显示 |
	jz ch2
	cmp byte ptr es:[bn],3              ; 3 则显示 \
	jz ch3
	cmp byte ptr es:[bn],4              ; 4 则显示 -
	jz ch4
	jmp showch
ch1:
    mov bp,offset str1
	jmp showch
ch2:
    mov bp,offset str2
	jmp showch
ch3:
    mov bp,offset str3
	jmp showch
	
ch4:
	mov byte ptr es:[bn],0
    mov bp,offset str4
	jmp showch

showch:
	mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标放到串尾
	mov bl,0ah 	                        ; 亮绿
	mov bh,0 	                    	; 第0页
	mov dh,24 	                        ; 第24行
	mov dl,78 	                        ; 第78列
	mov cx,1 	                        ; 串长为 1
	int 10h 	                    	; 调用10H号中断
	mov byte ptr es:[count],delay
End1:
	mov al,20h					        ; AL = EOI
	out 20h,al						    ; 发送EOI到主8529A
	out 0A0h,al					        ; 发送EOI到从8529A

	pop ax                              ; 恢复寄存器信息
	mov es,ax
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret		

	str1 db '\\'
	str2 db '|'
	str3 db '/'
	str4 db '-'
	delay equ 3				        ; 计时器延迟计数
	count db delay					     ; 计时器计数变量，初值=delay
	bn db 0
	
BIOSService_1:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0 	            	; 光标放到串尾
	mov bl,04h 	                ; 
	mov bh,0 		            ; 第0页
	mov dh,0 	                ; 第0行
	mov dl,0 	                ; 第0列
	mov bp,offset MES1          ; BP=串地址
	mov cx,504 	                ; 串长为 504
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,33h					; AL = EOI
	out 33h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

MES1:
    db "****************************************"
	db 0ah,0dh
	db "****                                ****"
	db 0ah,0dh
	db "****   name:  liaoyongbin           ****"
	db 0ah,0dh
	db "****   id:    17341097              ****"
	db 0ah,0dh
	db "****   class  4                     ****"
	db 0ah,0dh
	db "****                                ****"
	db 0ah,0dh
	db "****   int33                        ****"
	db 0ah,0dh
	db "****   program                      ****"
	db 0ah,0dh
	db "****                                ****"
	db 0ah,0dh
	db "****                                ****"
	db 0ah,0dh
	db "****                                ****"
	db 0ah,0dh
    db "****************************************"
	db 0ah,0dh,'$'

BIOSService_2:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0             		; 光标放到串尾
	mov bl,07h 	                ; 
	mov bh,0             		; 第0页
	mov dh,5 	                ; 第5行
	mov dl,44 	                ; 第44列
	mov bp,offset MES2 	        ; BP=串地址
	mov cx,30 	                ; 串长为 30
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,34h					; AL = EOI
	out 34h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

MES2:
    db "int34 is here!Can you see me?  "

BIOSService_3:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                 ; 功能号
	mov al,0 		             ; 光标放到串尾
	mov bl,07h 	                 ; 黄色
	mov bh,0 	                 ; 第0页
	mov dh,13 	                 ; 第13行
	mov dl,0 	                 ; 第0列
	mov bp,offset MES3 	         ; BP=串地址
	mov cx,479 	                 ; 串长为 479
	int 10h 		             ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,35h					; AL = EOI
	out 35h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

MES3:
    db "           O O           O O         "
	db 0ah,0dh
	db "         O     O       O     O        "
	db 0ah,0dh
	db "       O         O   O         O      "
	db 0ah,0dh
	db "      O            O            O     "
	db 0ah,0dh
	db "      O                         O     "
	db 0ah,0dh
	db "       O                       O      "
	db 0ah,0dh
	db "         O                   O        "
	db 0ah,0dh
	db "           O               O          "
	db 0ah,0dh
	db "             O           O            "
	db 0ah,0dh
	db "               O       O              "
	db 0ah,0dh
	db "                 O   O                "
	db 0ah,0dh
    db "                   O                  "
	db 0ah,0dh,'$'


BIOSService_4:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0 	             	; 光标放到串尾
	mov bl,71h 	                ; 白底深蓝
	mov bh,0 	                ; 第0页
	mov dh,18 	                ; 第18行
	mov dl,46 	                ; 第46列
	mov bp,offset MES4 	        ; BP=串地址
	mov cx,28 	                ; 串长为 28
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,36h					; AL = EOI
	out 36h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

MES4:
    db "Tomorrow is another day~ ^_^"

	;*************** ********************
;*  键盘中断程序
;**************** *******************
keyDo:
    push ax
    push bx
    push cx
    push dx
	push bp

	inc byte ptr es:[c]
	cmp byte ptr es:[c],24
	jnz continue
	call keyInit

continue:
	inc byte ptr es:[odd]
	cmp byte ptr es:[odd],1
	je print
	mov byte ptr es:[odd],0
	jmp next

print:
    mov ah,13h 	                    ; 功能号
	mov al,0                 		; 光标放到串尾
	mov bl,0ah 	                    ; 亮绿
	mov bh,0 	                	; 第0页
	mov dh,byte ptr es:[c] 	        ; 第 c 行
	mov dl,35 	                    ; 第35列
	mov bp, offset OUCH 	        ; BP=串地址
	mov cx,10  	                    ; 串长为 10
	int 10h 		                ; 调用10H号中断
    
next:
	in al,60h

	mov al,20h					    ; AL = EOI
	out 20h,al						; 发送EOI到主8529A
	out 0A0h,al					    ; 发送EOI到从8529A
	
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret							; 从中断返回

DelaySome:                          ; 延迟一段时间
    mov cx,delayTime      
toDelay:
	mov word ptr es:[t],cx          ; 把 cx 的值保存到 t 中
	mov cx,delayTime
	loop1:loop loop1 
	mov cx,word ptr es:[t]          ; 把 t 的值放回 cx ，恢复 cx
	loop toDelay
	ret

Clear: ;清屏
    MOV AX,0003H
    INT 10H
	ret

keyInit:                            ; 初始化 OUCH！OUCH！显示的行数为 0 
    mov byte ptr es:[c],0           ; 设置变量 c
	ret

OUCH:
    db "OUCH!OUCH!"
	c db 10
	odd db 1

	delayTime equ 40000
	t dw 0
