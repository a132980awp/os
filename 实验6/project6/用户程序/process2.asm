;;**********************************************************************************
;;    				程序功能：利用时钟中断，在显示框右上角画框
;;						程序原作：凌应标
;;**********************************************************************************

delay equ 2000					; 计时器延迟计数,用于控制画框的速度
ddelay equ 580					; 计时器延迟计数,用于控制画框的速度


    org 100h					; 程序加载到100h，可用于生成COM
	;org 7c00h

;初始化段寄存器
	mov ax,200						; AX = 0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
    mov word[count],delay
	mov word[dcount],ddelay

LABEL_SHOW_ID:	
	mov ah,0eh
	mov al,'1'
	mov word[gs:((80 * 7 + 56) * 2)], ax
	mov al,'7'
	mov word[gs:((80 * 7 + 57) * 2)], ax
	mov al,'3'
	mov word[gs:((80 * 7 + 58) * 2)], ax
	mov al,'4'
	mov word[gs:((80 * 7 + 59) * 2)], ax
	mov al,'1'
	mov word[gs:((80 * 7 + 60) * 2)], ax
	mov al,'0'
	mov word[gs:((80 * 7 + 61) * 2)], ax
	mov al,'9'
	mov word[gs:((80 * 7 + 62) * 2)], ax
	mov al,'7'
	mov word[gs:((80 * 7 + 63) * 2)], ax
 
    mov word[x],0
    mov word[y],40
	mov byte[rdlu], 2             ; 当前画框的方向, 1-向右,2-向下,3-向左,4-向上
    mov word[char],'A'
	
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
    call boxing
	mov word[count],delay
	mov word[dcount],ddelay
    jmp loop1	
	
	jmp $						; 死循环

datadef:

	count dw delay				; 计时器计数变量，初值=delay
	dcount dw ddelay			; 计时器计数变量，初值=delay
	x dw 0                      ; 当前字符显示位置的行号,0~24
	y dw 0                      ; 当前字符显示位置的列号,0~79
	rdlu db 2                   ; 当前画框的方向, 1-向右,2-向下,3-向左,4-向上
	char db 'A'                 ; 当前显示字符

	
boxing:
	
right:
    mov al,byte[rdlu]           ;右 
	cmp al,1
	jnz down
	mov ax,word[y]              ;最后一列?
	cmp ax, 79
	jz r2d
	inc byte[y]
	jmp show
r2d:
    mov byte[rdlu],4            ;改为向上
	dec byte[x]
	jmp show
	
down:
    mov al,byte[rdlu]           ;向下 
	cmp al,2
	jnz left
	mov ax,word[x]              ;最后一行?
	cmp ax, 12
	jz d2l
	inc byte[x]
	jmp show
d2l:
    mov byte[rdlu],1           ;改为向右
	inc byte[y]
	jmp show

left:
    mov al,byte[rdlu]           ;向左 
	cmp al,3
	jnz up
	mov ax,word[y]              ;最左一列?
	cmp ax, 40
	jz l2u
	dec byte[y]
	jmp show
l2u:
    mov byte[rdlu],2           ;改为向下
	inc byte[x]
	jmp show
	
up:
    mov al,byte[rdlu]           ;向上 
	cmp al,4
	jnz end
	mov ax,word[x]              ;最上一行?
	cmp ax, 0
	jz u2r
	dec byte[x]
	jmp show
u2r:
    mov byte[rdlu],3            ;改为向左
	dec byte[y]
	mov al,byte[char]
	cmp al,'Z'
	jz returntoa
	inc byte[char]
	jmp show
	
returntoa:
    mov byte[char],'A' 
	jmp show

show:	
    xor ax,ax                      ; 计算当前字符的显存地址 gs:((80*x+y)*2)
    mov ax,word[x]
	mov bx,80                  ; (80*x
	mul bx
	add ax,word[y]             ; (80*x+y)
	mov bx,2
	mul bx                     ; ((80*x+y)*2)
	mov bp,ax
	mov ah,0bh		   ; 0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[char]	   ; AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  	   ;   显示字符的ASCII码值

end:
	ret
    jmp $	
	
	times 512-($-$$) db 0 ; $=当前地址、$$=当前节地址
; 写入启动扇区的结束标志
	;db 55h,0aah

