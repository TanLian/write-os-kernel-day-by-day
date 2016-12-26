[bits 16]
boot:
	;Clear ds and es
	xor ax,ax
	mov ds,ax
	mov es,ax
	
	;I am going to move LOADER from floppy to memory(address is 0x8000)
	mov ax,0x800
	mov es,ax
	xor bx,bx
	
	mov ch,0 ;set track to 0
	mov cl,2 ;set starting sector number to 2
	mov dh,0 ;set magnetic top to 0
	mov dl,0 ;set drive to 0
rp_read:	
	mov ah,2 ;function number,it means i am going to read floppy
	mov al,1 ;number of sectors to read
	int 0x13 ;boom
	jc rp_read ;if errors happen, repeat
	
	;jmp 0x8000
	jmp 0x800:0
	
times 510-($-$$) db 0
db 0x55,0xaa
