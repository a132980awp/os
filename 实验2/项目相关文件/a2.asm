; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.
;  ��Ӧ�� 2014/3
;   NASM����ʽ
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

    org 8500h					; ������ص�a100h������������COM
start:
	;xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
      mov ax,cs
	mov es,ax					; ES = 0	?
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h
    mov byte[char],'B'	
	call DispStr
loop1:
	dec word[count]				; �ݼ���������
	jnz loop1					; >0����ת;
	mov word[count],delay
	dec word[dcount]				; �ݼ���������
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
      xor ax,ax                 ; �����Դ��ַ
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,byte[color]	;  0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	mov al,byte[char]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ
	
	inc word[x]
      xor ax,ax                 ; �����Դ��ַ
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,byte[color]	;  0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	mov al,byte[char]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ	
	dec word[x]
	
	call DispStr
	dec word[countx]
	cmp word[countx],0
		jz end
	jmp loop1
	
end:
	mov word[countx],100
    jmp 7c00h                   ; ֹͣ��������ѭ�� 
	
datadef:	
	countx dw 100 
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; �������˶�
    x    dw 7
    y    dw 39
	color    dw 01h
    char db 'B'

DispStr:   
    mov ax, BootMessage   
    mov bp, ax ; es:bp = ����ַ   
    mov cx, 20 ; cx = ������   
	mov ah,0	;  0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	mov al,byte[color]			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov bx,ax
    ;mov bx, 000ch ; ҳ��Ϊ 0(bh = 0) �ڵ׺���(bl = 0Ch,����) 
	mov ax, 01301h ; ah = 13, al = 01h    
    mov dl, 0   
	int 10h
    ret

BootMessage:   
    db "17341097 liaoyongbin"   
    times 510-($-$$) db 0 ; ���ʣ�µĿռ䣬ʹ���ɵĶ����ƴ���ǡ��Ϊ   
    dw 0xaa55 ; ������־  