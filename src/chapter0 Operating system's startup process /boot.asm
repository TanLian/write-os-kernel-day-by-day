mov ax,0xb800
mov gs,ax
mov ah,0x04
mov al,'H'
mov [gs:0],ax
mov al,'E'
mov [gs:2],ax
mov al,'L'
mov [gs:4],ax
mov al,'L'
mov [gs:6],ax
mov al,'O'
mov [gs:8],ax
jmp $

times 510-($-$$) db 0
db 0x55,0xaa
