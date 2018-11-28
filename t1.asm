.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
 option casemap:none                ; case sensitive

.data ; start of a data section
public g ; export variable g
g DWORD 4 ; declare global variable g initialised to 4
.code ; start of a code section



public min
min:
	 push ebp               ; push frame pointer
  mov ebp, esp			; update ebp
	push ebx				; save non volatile registers used by function
  mov eax, [ebp+8]		; eax = a

	 cmp eax,[ebp + 12]		; compare a with b
	 jle notless			; jump if less then or equal
	 mov eax,[ebp + 12]		; a = b
notless:
	 cmp eax,[ebp + 16]		; compare a with
	 jle notless2			; jump if less than or equal
	 mov eax,[ebp + 16]		; a = c
notless2:
	 pop ebx				; restore saved registers
	 mov esp, ebp			; restore esp
	 pop ebp				; restore previous ebp
	 ret 0					; return 0




public p
p:
	 push    ebp            ; push frame pointer
   mov     ebp, esp       ; update ebp
	 push ebx				; save non volatile registers used by function
	 mov eax,[ebp + 20]     ; i
	 mov ebx,[ebp + 16]		; j

	 push g					; push g onto stack
	 push eax				; push i onto stack
	 push ebx				; push j onto stack

	 call min				; get min of i,j,g

	 mov ebx, [ebp + 12]		; ebx = k
	 mov ecx, [ebp +8]		; ecx = l

	 push eax				; push answer of last min onto stack
	 push ebx				; push k onto stack
	 push ecx				; push l onto stack
	 call min				; call min on last min, k,l

	 pop ebx				; restore saved registers
	 mov esp, ebp			; restore esp
	 pop ebp					; restore previous ebp
	 ret 0					; return 0





	public gcd
gcd:
	 push    ebp            ; push frame pointer
     mov     ebp, esp       ; update ebp
	 push ebx				; save non volatile registers used by function
	 mov ebx, [ebp + 12]	; x
	 mov eax, [ebp + 8]		; y

	 cmp ebx,0				; compare y with 0
	 jg notZero				; jump if greater than
	 jmp finish				; branch to finish
notZero:
	cdq						; convert word to double word
	idiv ebx				; div eax by ecx
	push edx				; push y onto the stack
	push ebx				; push remainder of division onto stack stored in edx
	call gcd				; recurse function
finish:
	pop ebx					; restore saved registers
	mov esp, ebp			; restore esp
	pop ebp					; restore previous ebp
	ret 0					; return 0

	end
