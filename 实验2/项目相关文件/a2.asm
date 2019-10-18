; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度

    org 8500h					; 程序加载到a100h，可用于生成COM
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
      mov ax,cs
	mov es,ax					; ES = 0	?
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
    mov byte[char],'B'	
	call DispStr
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

      mov al,1
      cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,13
	sub ax,bx
      jz  dr2ur
	mov bx,word[y]
	mov ax,76
	sub ax,bx
      jz  dr2dl
	jmp show
dr2ur:
      mov word[x],11
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:
      mov word[y],74
      mov byte[rdul],Dn_Lt	
      jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,76
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,1
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
      mov word[y],74
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],3
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,37
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],3
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],39
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,37
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,13
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],39
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],11
      mov byte[rdul],Up_Lt	
      jmp show
	
reset:
	mov byte[color],00h

show:		
	cmp byte[color],0fh
	  jz reset
	inc byte[color]
      xor ax,ax                 ; 计算显存地址
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,byte[color]	;  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	
	inc word[x]
      xor ax,ax                 ; 计算显存地址
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,byte[color]	;  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值	
	dec word[x]
	
	call DispStr
	dec word[countx]
	cmp word[countx],0
		jz end
	jmp loop1
	
end:
	mov word[countx],100
    jmp 7c00h                   ; 停止画框，无限循环 
	
datadef:	
	countx dw 100 
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 7
    y    dw 39
	color    dw 01h
    char db 'B'

DispStr:   
    mov ax, BootMessage   
    mov bp, ax ; es:bp = 串地址   
    mov cx, 20 ; cx = 串长度   
	mov ah,0	;  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[color]			;  AL = 显示字符值（默认值为20h=空格符）
	mov bx,ax
    ;mov bx, 000ch ; 页号为 0(bh = 0) 黑底红字(bl = 0Ch,高亮) 
	mov ax, 01301h ; ah = 13, al = 01h    
    mov dl, 0   
	int 10h
    ret

BootMessage:   
    db "17341097 liaoyongbin"   
    times 510-($-$$) db 0 ; 填充剩下的空间，使生成的二进制代码恰好为   
    dw 0xaa55 ; 结束标志  