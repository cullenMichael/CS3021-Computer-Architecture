option casemap:none             ; case sensitive
 
.data ; start of a data section
includelib legacy_stdio_definitions.lib
extrn printf:near
public g ; export variable g
g QWORD 4 ; declare global variable g initialised to 4
.code ; start of a code section


public min

min:
	push rbx			; save rbx
	mov rax,rcx			; mov to rax
	cmp rax, rdx		; compare first val to second value
	jle jump			; if less, jump 
	mov rax, rdx		; else rax is second calue	
jump:
	cmp rax, r8			; compare rax with third value
	jle jumpn			; if less, jump
	mov rax, r8			; else rax is third value
jumpn:
	pop rbx				; restore rbx
	ret 0				; return


public gcd
gcd:
	cmp rdx,0				; compare second parameter with 0
	jg notZero				; jump if greater than
	jmp finish				; branch to finish
notZero:  
	mov rax, rcx			; mov first param to rax
	mov rcx, rdx			; mov second papram to rdx
	cqo						; convert word to octoword
	idiv rcx				; divide 
	sub rsp, 32				; allocate stack space
	call gcd				; recall gcd
	add rsp, 32				; return stack space
finish:
	mov rax,rcx				; return answer in rax
	ret 0



public p
p:
	push rbx				; save rbx
	mov rbx, r8				; mov rbx with r8
	mov r8, g				; mov g into r8
	sub rsp, 32				; allocate stack space
	call min				; call min
	add rsp, 32				; take back stack space
	mov r8,rbx				; mov rbx into r8
	mov rcx,rax				; mov ans from last min into rcx
	mov rdx,r9				; mov r9 into rdx
	sub rsp, 32				; allocate stack space
	call min				; call min
	add rsp, 32				; take back stack space
	pop rbx					; pop rbx
	ret 0					; return


fxp2 db 'a = %I64d b = %I64d c = %I64d d = %I64d e = %I64d sum = %I64d', 0AH, 00H


public q
q:
  push rbx					; save rbx
  sub rsp, 48				; allocate stack space + room for params
  mov rbx ,[ rsp + 96]		; get value from the stack as papram 5
  mov rax,rcx				;
  add rax,rdx				;
  add rax, r8				;
  add rax,r9				;
  add rax, rbx				; SUM CORRECT IN EAX

  mov [rsp + 48], rax		; push rax onto stack
  mov [rsp + 40], rbx		; push rbx onto stack
  mov [rsp + 32], r9		; push r9 onto stack

  mov rbx,rax				; restore rbx 

  mov r9,r8					; mov r9 into r8
  mov r8, rdx				; mov rdx into r8
  mov rdx,rcx				; mov rcx intp rdx
  lea rcx ,fxp2				; load string into rcx
  call printf				; call printf
 
  mov rax,rbx				; return sum in rax
  add rsp, 48				; deallocate shadow space
  pop rbx					; restore rbx
  ret 0						; return


fxp1 db 'qns', 0AH, 00H

public qns
qns:
    sub rsp, 32			; allocate stack space
	lea rcx,fxp1		; load string into rcx
	call printf			; call printf
	add rsp, 32			; deallocate stack space
	
	;call printf        ; uncomment to call printf with no shadow space, crashes
	mov rax,0			; return 0 in rax
	ret 0;				; return



end