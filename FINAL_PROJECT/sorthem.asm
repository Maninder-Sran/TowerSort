extern rconf
%include "asm_io.inc"

SECTION .data

initial: db "          initial configuration",10,0
final :  db "          final configuration"  ,10,0
error1:  db "incorrect number of command line arguements",10,0
error2:  db "incorrect command line arguement"           ,10,0
array:   dd 0,0,0,0,0,0,0,0,0
line_1:  db "                    o|o "          ,10,0
line_2:  db "                   oo|oo "         ,10,0
line_3:  db "                  ooo|ooo "        ,10,0
line_4:  db "                 oooo|oooo "       ,10,0
line_5:  db "                ooooo|ooooo "      ,10,0
line_6:  db "               oooooo|oooooo "     ,10,0
line_7:  db "              ooooooo|ooooooo "    ,10,0
line_8:  db "             oooooooo|oooooooo "   ,10,0
line_9:  db "            ooooooooo|ooooooooo "  ,10,0
line_X:  db "          XXXXXXXXXXXXXXXXXXXXXXX ",10,0

SECTION .bss

counter: resd 1
size:    resd 1
address: resd 1

SECTION .text
	global asm_main

asm_main:
	enter 0,0 
	pusha
	
	mov eax, dword [ebp+8] ;argc
	cmp eax, dword 2
	jne ERROR1
	mov ebx, dword [ebp+12] ;argv
        mov eax, dword [ebx+4]  ;argv[1]
	cmp [eax+1], byte 0     ;check that it is only one digit
	jne ERROR2
	mov ebx, dword 0
	mov bl, byte [eax]
checkNum:			;check that input is >= 2 & <= 9 
	cmp bl, '2'
	jb ERROR2
	cmp bl, '9'
	ja ERROR2
CONT1:
	mov eax, initial	
	call print_string 
	sub bl, '0'		;convert input to integer
	push ebx
	mov ecx, array
	push ecx
	call rconf		;fill array with random numbers
	pop ecx
	pop ebx
	mov [size], ebx
	mov [address], ecx
	push ebx
	push ecx
	call showp		;print intial tower config
	call showp		;reprint initial tower config
	call sorthem		;sort the tower and print the configs
	mov eax, final
	call print_string
	call showp		;print the final tower config
	add esp,8
	jmp main_end
showp:
	enter 0,0
	pusha
	mov ebx, dword [ebp+8]
	mov ecx, dword [ebp+12]
	mov [counter], dword 36 ;iterate by starting from the end of the array
display_tower:			;print the tower line by line depending on the number
	sub [counter], dword 4
	cmp [counter], dword 0
	jl showp_end
	mov eax, [counter]
	mov edx, [ebx+eax]
	cmp edx, 0
	je display_tower
	cmp edx, dword 1
	je print1
	cmp edx, dword 2
	je print2
	cmp edx, dword 3
	je print3
	cmp edx, dword 4
	je print4
	cmp edx, dword 5
	je print5
	cmp edx, dword 6
	je print6
	cmp edx, dword 7
	je print7
	cmp edx, dword 8
	je print8
	cmp edx, dword 9
	je print9
	
CONT_PRINT:
	call print_string
	jmp display_tower
print1:
	mov eax, line_1
	jmp CONT_PRINT
print2:
	mov eax, line_2
	jmp CONT_PRINT
print3:
	mov eax, line_3
	jmp CONT_PRINT
print4:
	mov eax, line_4
	jmp CONT_PRINT
print5:
	mov eax, line_5
	jmp CONT_PRINT
print6:
	mov eax, line_6
	jmp CONT_PRINT
print7:
	mov eax, line_7
	jmp CONT_PRINT
print8:
	mov eax, line_8
	jmp CONT_PRINT
print9:
	mov eax, line_9
	jmp CONT_PRINT

sorthem:
	enter 0,0
	pusha
	
	mov eax, dword [ebp+8]
	mov ebx, dword [ebp+12]

	cmp ebx, dword 1	;if n = 1 then return
	je sorthem_end
	mov ecx, eax
	add ecx, dword 4
	sub ebx, dword 1
	push ebx
	push ecx
	call sorthem		;sorthem(A+1, n-1)
	pop ecx
	pop ebx
	mov [counter], dword 0
	mov ecx, dword 4
loop:
	cmp [counter], ebx	;if i = n-1 then loop_end
	je loop_end
	mov edx, [eax+ecx]
	cmp [eax+ecx-4], edx	;if A[i] > A[i+1] then loop_end
	jg loop_end
	jmp swap		;if A[i] < A[i+1] then swap the elements
CONT_LOOP:
	add ecx, dword 4
	inc dword [counter]
	jmp loop
swap:				;swap A[i+1] with A[i]
	mov ebx, [eax+ecx]
	mov edx, [eax+ecx-4]
	mov [eax+ecx], edx
	mov [eax+ecx-4], ebx
	mov ebx, dword [ebp+12]
	sub ebx, dword 1
	jmp CONT_LOOP
loop_end:
	push dword [size]
	push dword [address]
	call showp		;display the current tower config
	add esp, 8
	jmp sorthem_end
ERROR1:				;incorrect number of command line arguements
	mov eax, error1
	call print_string
	jmp main_end
ERROR2: 			;incorrect command line arguement
	mov eax, error2
	call print_string
	jmp main_end
main_end:
	popa
	leave
	ret
showp_end:
	mov eax, line_X
	call print_string
	call read_char
	popa
	leave
	ret
sorthem_end:
	popa
	leave
	ret
