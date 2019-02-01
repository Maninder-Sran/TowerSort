%include "asm_io.inc"

SECTION .data
	
error1: db "Incorrect number of command line arguements",10,0	
error2: db "Incorrect arguement length, size expected: 2",10,0
error3: db "Invalid type for first chracter, expected: int",10,0
error4: db "Invalid digit entered, expected: > 1 & odd",10,0
error5: db "Invalid second character, expected: upper case letter",10,0

SECTION .text
	global asm_main
asm_main:
	enter 0,0
	pusha
	
	mov eax, dword [ebp+8]
	cmp eax, dword 2
	jne ERR1
	mov ebx, dword [ebp+12]
        mov eax, dword [ebx+4]
	cmp [eax+2], byte 0
	jne ERR2
        mov bl, byte [eax]
        jmp checkNum
CONT1:
	sub bl, '0'
	mov ecx, 0
	mov cl, bl
	jmp compareNum
CONT2:
	mov bl, byte [eax+1]
	jmp checkChar
	
asm_main_end:
	popa
	leave
	ret
checkNum:
	cmp bl, '0'
        jb ERR3
	cmp bl, '9'
	ja ERR3
	jmp CONT1
compareNum:
	cmp cl, 1
	jle ERR4
	test cl,1
	jz ERR4
	jmp CONT2
checkChar:
	cmp bl, 'A'
  	jb ERR5
	cmp bl, 'Z'
	ja ERR5
	push ebx
	push ecx
	call display_shape
	add esp,8
	jmp asm_main_end
display_shape:
	enter 0,0
	pusha
	mov al, byte [ebp+12]
	mov ecx, dword [ebp+8]
	mov edx, ecx 		
printShape:
	cmp edx, dword 0
	je end1
	cmp edx, 1
	je multi_char
single_char:
	mov ebx, ecx
	sub ebx, 1
	push ebx
	mov ebx, 1
	jmp cont
multi_char:
	mov ebx, 0
	push ebx
	mov ebx, ecx
cont:
	push ebx
	push eax
	call display_line
	add esp, 12
	dec edx
	jmp printShape
end1:
	popa
	leave
	ret
display_line:
	enter 0,0
	pusha
	mov al, byte ' '    ;letter
	mov ebx, dword [ebp+12] ;# of letters
	mov ecx, dword [ebp+16] ;# of spaces
	mov edx, ecx
	jmp print_spaces_front
point1:	
	mov al, byte [ebp+8]
	mov edx, ebx
	cmp ebx, 1
	jne print_letter
	call print_char
point2:
	mov al, byte ' '
	mov edx, ecx
	jmp print_spaces_end
print_spaces_front:
	cmp edx, 0
	je point1
	call print_char	
	dec edx
	jmp print_spaces_front
print_letter:
	cmp edx, 0
	je point2
	call print_char
	mov al, byte ' '
	call print_char
	mov al, byte [ebp+8]
	dec edx
	jmp print_letter
print_spaces_end:
	cmp edx, 0
	je end2
	call print_char
	dec edx
	jmp print_spaces_end
end2:
	call print_nl
	popa
	leave 
	ret
ERR1:
	mov eax, error1
	call print_string
	jmp asm_main_end
ERR2:
	mov eax, error2
	call print_string
	jmp asm_main_end
ERR3:
	mov eax, error3
	call print_string
	jmp asm_main_end
ERR4:
	mov eax,error4
	call print_string
	jmp asm_main_end
ERR5:
	mov eax, error5
	call print_string
	jmp asm_main_end
