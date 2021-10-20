; Author: Jingwei Geng.
; Course number / section:CS_271_001_U2020
; Project ID : Final_project						Due date : Aug 14 by 11 : 59pm
; Description:
;				Alex and Sila are espionage agents working for the Top Secret Agency(TSA).Sometimes they
;			discuss sensitive intelligence information that needs to be kept secret from the Really Bad Guys
;			(RBG).Alex and Sila have decided to use a simple obfuscation algorithm that should be good
;			enough to confuse the RBG.As the TSA¡¯s resident programmer you¡¯ve been assigned to write a
;			 MASM procedure that will implement the requested behavior.Your code must be capable of
;			encrypting and decrypting messages(and meet the other requirements given in this document).This
;			final project is written less like an academic assignment and more like a real - life programming task.
;			This might seem daunting at first but don¡¯t despair!
;
; **EC:Ensure that the "decoy" mode correctly returns the sum of ANY signed 16 bit numbers
; **EC:Implement the key generation mode as described in the documentation.


Include Irvine32.inc
; notes:
; 1) In decoy mode, the third parameter(32 bit OFFSET of a signed DWORD) should be initialized with 0 to distinguish with other modes.
; 2) I use the push - pop idiom, so the used registers will not change after the function's finishment. I will not mention this agin in the follwoing 
small_letter_a = 97
small_letter_z = 122
.code
; Title:				compute
; Description:		different computer accoding to different mode
; Receives:
; decoy: value1(value, 2 bytes), value2(value, 2 bytes), destination(reference), mode(value : 0)
; encryption: key(reference), message(reference), mode(value : -1)
; decryption: key(reference), message(reference), mode(value : -2)
; generate: key(reference), mode(value : -3)
; Returns:			none
; Precondition:		none
; Registers changed : none
compute PROC
push ebp
mov ebp, esp

push edx
; parse the mode parameter
mov edx, [ebp + 8]
mov edx, [edx]
; different process according to mode content
cmp edx, -1
jz encryption_mode

cmp edx, -2
jz decryption_mode

cmp edx, -3
jz generation_mode

jmp decoy_mode
; encryption
encryption_mode :
push[ebp + 16]
push[ebp + 12]
call encryption
pop edx
pop ebp
ret 12
; decryption
decryption_mode :
push[ebp + 16]
push[ebp + 12]
call decryption
pop edx
pop ebp
ret 12
; generation
generation_mode :
push[ebp + 12]
call generation
pop edx
pop ebp
ret 8
; decoy
decoy_mode :
push[ebp + 12]
push[ebp + 8]
call decoy
pop edx
pop ebp
ret 8

compute ENDP

; Title:				encryption
; Description:		encrypt the arr with key
; Receives:			arr(reference), key(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
encryption PROC
push ebp
mov ebp, esp
push ebx
push ecx
push edx

mov ebx, [ebp + 8]
loop_encryption_0:
mov	cl, BYTE PTR[ebx]
cmp cl, 0
; null check
jz encryption_exit
; small letter check
cmp cl, small_letter_a
jl loop_encryption_0_continue
cmp cl, small_letter_z
jg loop_encryption_0_continue
; get the letter index, 'a' is 0, 'b' is 1, ..., 'z' is 25
sub cl, small_letter_a
movzx ecx, cl
mov edx, [ebp + 12]
add edx, ecx
; complete the translation
mov cl, BYTE PTR[edx]
mov BYTE PTR[ebx], cl
loop_encryption_0_continue :
inc ebx
jmp loop_encryption_0
encryption_exit :
pop edx
pop ecx
pop ebx
pop ebp
ret 8
encryption ENDP

; Title:				decryption
; Description:		decrypt the arr with key
; Receives:			arr(reference), key(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
decryption PROC
push ebp
mov ebp, esp
push eax
push ebx
push ecx
push edx

; allocate 26 bytes, 26 will be rounded to 28
sub esp, 28
mov edx, esp
mov eax, [ebp + 12]
mov ecx, 0
; get the reversed key from original key
decryption_loop_0 :
cmp ecx, 26
jge decryption_loop_exit
mov ebx, eax
add ebx, ecx
mov bl, BYTE PTR[ebx]
sub bl, small_letter_a
movzx ebx, bl
push eax
mov eax, edx
add eax, ebx
mov BYTE PTR[eax], cl
add BYTE PTR[eax], small_letter_a
pop eax
inc ecx
jmp decryption_loop_0
decryption_loop_exit :
; it will be same to encryption, besides the reversed key
push edx
push[ebp + 8]
call encryption
add esp, 28
pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret 8
decryption ENDP

; Title:				Exchange
; Description:		swap 2 values
; Receives:			v1(reference), v2(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
Exchange PROC
push ebp
mov ebp, esp

push eax
push ebx
push ecx
push edx
; swap the value between the two address
mov eax, [ebp + 12]
mov ebx, [ebp + 8]
cmp ebx, eax
jz exchange_exit
mov ecx, [eax]
mov edx, [ebx]
mov[eax], edx
mov[ebx], ecx

exchange_exit :
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 8
Exchange ENDP

; Title:				generation
; Description:		random shuffle a, b, c, ...., z
; Receives:			arr(reference)
; Returns:			none
; Precondition:		none
; Registers changed : none
generation PROC
push ebp
mov ebp, esp
; call it at the beginning of generation
call Randomize
push eax
push ebx
push ecx
push edx

; an array contains 26 integers
sub esp, 104; 104 = 4 * 26
mov edx, esp

mov ecx, 26
mov ebx, 0
; initialize the array with 0, 1, 2, ..., 25
initial_loop:
mov[edx + 4 * ebx], ebx
inc ebx
loop initial_loop


; get a random integer i from[0, 1, ..., ecx), then swap array[i] and array[ecx - 1]
mov ecx, 26; left generation char
generation_loop :
cmp ecx, 1
jle generation_loop_exit
mov eax, ecx
call RandomRange

lea ebx, [edx + 4 * eax]
push ebx
lea ebx, [edx + 4 * ecx]
sub ebx, 4
push ebx
call Exchange

dec ecx
jmp generation_loop

generation_loop_exit :

mov ecx, 26
mov ebx, 0
; fill the result array(its address is[ebp + 8]), accoding to  the above array.
assign_loop:
mov eax, [ebp + 8]
add eax, ebx
push edx
mov dl, [edx + 4 * ebx]
mov BYTE PTR[eax], dl
add BYTE PTR[eax], small_letter_a
inc ebx
pop edx
loop assign_loop

add esp, 104

pop edx
pop ecx
pop ebx
pop eax
pop ebp
ret 4
generation ENDP

; Title:				decoy
; Description:		v3 = v1 + v2
; Receives:			v1(value, 2 bytes), v2(value, 2 bytes), v3(reference, 4 bytes)
; Returns:			none
; Precondition:		none
; Registers changed : none
decoy PROC
push ebp
mov ebp, esp
push eax
push ebx
; the first parameter
mov ax, WORD PTR[ebp + 14]
movsx eax, ax
; the second parameter
mov bx, WORD PTR[ebp + 12]
movsx ebx, bx
add eax, ebx
; the third parameter
mov ebx, [ebp + 8]
mov[ebx], eax

pop ebx
pop eax
pop ebp
ret 8
decoy ENDP

END
