[bits 16]
pm_mode:
	jmp code
;GDT
gdt:
;Must be a null descriptor
dw 0x0000,0x0000,0x0000,0x0000
;Code segment(0~4GB),rx
dw 0xffff,0x0000,0x9a00,0x00cf
;Data segment(0~4GB),rw
dw 0xffff,0x0000,0x9200,0x00cf

gdt_48:
	dw 23
	dd 0x50000

code:
	;Clear ds and es
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	;I am going to move KERNEL from floppy to memory(address is 0x6000)
	mov ax,0x600
	mov es,ax
	xor bx,bx
	
	mov ch,0 ;track
	mov cl,3 ;starting sector number
	mov dh,0 ;magnetic top
	mov dl,0 ;drive
rp_read:	
	mov ah,2 ;function number
	mov al,1 ;number of sectors to read
	int 0x13
	jc rp_read
	
	;Clear IF
	cli
	
	;Move GDT to 0x50000 ds:si ---->es:di
	cld
	xor ax,ax
	mov ds,ax
	mov ax,0x5000
	mov es,ax
	mov si,gdt
	xor di,di
	mov cx,24>>2
	rep
	movsd
	
	
	;Open A20
enable_a20:
	in al,0x64
	test al,0x2
	jnz enable_a20
	mov al,0xdf
	out 0x64,al
	
	;Set gdtr register
	lgdt [gdt_48]
	
	;Enter pro mode
	mov eax,cr0
	or eax,0x1
	mov cr0,eax

	;jmp
	jmp 0x08:0x6000
	
times 512-($-$$) db 0
