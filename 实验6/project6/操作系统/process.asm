extern _sector_number:near
extern _current_seg:near
extern _create_new_PCB:near
extern _kernal_mode:near
extern _process_number:near
extern _current_process_number:near
extern _first_time:near
extern _save_PCB:near
extern _schedule:near
extern _get_current_process_PCB:near
extern _initial_PCB_settings:near

;=========================================================================
;					void _set_timer()
;=========================================================================
public _set_timer
_set_timer proc
	push ax
	mov al, 36h
	out 43h, al
	mov ax, 11931		;频率为100Hz
	out 40h, al
	mov al, ah
	out 40h, al
	pop ax
	ret
_set_timer endp
;=========================================================================
;					void _set_clock()
;=========================================================================
public _set_clock
_set_clock proc
	push es
	call near ptr _set_timer
	xor ax, ax
	mov es, ax
	mov word ptr es:[20h], offset Timer
	mov word ptr es:[22h], cs
	pop es
	ret
_set_clock endp

back_time dw 1
;=========================================================================
;					void _run_process(int start, int seg)
;=========================================================================
public _run_process
_run_process proc
	push es
	
	mov ax, word ptr [_current_seg]
	mov es, ax
	mov bx, 100h
	mov ah, 2
	mov al, 1
	mov dl, 0
	mov dh, 1
	mov ch, 0
	mov cl, byte ptr [_sector_number]
	int 13h
	
	call _create_new_PCB
	
	pop es
	ret
_run_process endp

