; Author: Jingwei Geng.
; Course number / section:CS_271_001_U2020
; Project ID : Program#3						Due date : Jul 26 by 11 : 59pm
; Description:
;		Write a program to calculate composite numbers.First, the user is instructed to enter the number of
;		composites to be displayed, and is prompted to enter an integer in the range[1 .. 300].The user
;		 enters a number, n, and the program verifies that 1 ¡Ü n ¡Ü 300. If n is out of range, the user is reprompted
;		until they enter a value in the specified range.The program then calculates and displays all
;		of the composite numbers up to and including the nth composite.The results should be displayed 10
;
INCLUDE Irvine32.inc

.data

; declare the introduce parts

Info_1			    BYTE "Welcome to the Composite Number Spreadsheet", 0
Info_2				BYTE "Programmed by Jingwei Geng.", 0
Info_3				BYTE "This program is capable of generating a list of composite numbers.", 0
Info_4				BYTE "Simply let me know how many you would like to see.", 0
Info_5              BYTE "I¡¯ll accept orders for up to 300 composites.", 0
Info_6				BYTE "How many composites do you want to view? [1 .. 300]: ", 0
Hello_world         BYTE "Hello,World", 0

user_input			DWORD ?
comp_number         DWORD ?
waiting_number      DWORD ?
Div_number          DWORD ?
Bool_Function       DWORD ?



Error_info			BYTE "Out of range. Enter a number in [1 .. 46]", 0
space				BYTE "   "





Endmessage_1		BYTE "Thanks for using my program!", 0




lower_limit = 1
upper_limit = 300


; ------------------------------------------------
; prpcedure: main(call other functions)
; receives: none
; returns: no return
; preconditions: none
; registers changed : eax, ecx, edx
; ------------------------------------------------

.code
main PROC

call introduction
call getUserData
; call showComposities
call goodbye



exit
main ENDP



; ------------------------------------------------
; procedure:introduction(to intruduce the program)
; receives: Info_1 Info_2 Info_3 Info_4 Info_5 are infomation
; returns: no return
; preconditions: none
; registers changed : none
; ------------------------------------------------
introduction PROC
														;output the introduction message
	mov		edx, OFFSET Info_1
	call	WriteString
	call    Crlf
	mov		edx, OFFSET Info_2
	call	WriteString
	call    Crlf
	mov		edx, OFFSET Info_3
	call	WriteString
	call    Crlf
	mov		edx, OFFSET Info_4
	call	WriteString
	call    Crlf
	mov		edx, OFFSET Info_5
	call	WriteString
	call    Crlf


	ret
introduction ENDP



; ------------------------------------------------
; prpcedure: getUserData(get user input and check valid data)
; receives: Info_6 is information,lower_limit and upper_limit are constant.
; returns: user_input
; preconditions: user_input > 1 and user_input < 300
; registers changed : eax
; ------------------------------------------------
getUserData PROC


getuserinput:
	mov		edx, OFFSET Info_6
	call	WriteString
	call    Crlf
	call	ReadInt
	mov		user_input, eax								;store the user_number
	cmp		eax,lower_limit
	jl		validata
	cmp     eax,upper_limit								;compare the number greater or less than validata
	jg      validata
	jmp     next_round
		

validata:
	mov		edx, OFFSET Error_info
	call	WriteString
	call	Crlf
    jmp     getuserinput

next_round:
	
	ret
getUserData ENDP






; ------------------------------------------------
; prpcedure: showComposities(show same amount of composities number)
; receives: user_input is a variable
; returns: no return
; preconditions: user_input > 1 and user_input < 300
; registers changed : eax, ecx, edx
; ------------------------------------------------


showComposities  PROC

call	Crlf
call	Crlf

mov  eax, 4
mov  waiting_number, eax

mov eax,user_input
		
isComposites:
	mov eax,waiting_number
	call check_prime_number
	cmp Bool_Function,1
	je Output_number
	jne next_number


next_number:
	inc waiting_number
	loop isComposites

Output_number :
	mov eax, waiting_number
	call WriteDec
	mov eax, OFFSET space
	call WriteString
	inc comp_number
	
	mov comp_number,ebx
	mov ebx,10
	div ebx
	cmp edx,0
	je	next_line
	jne keep_line



next_line:
	mov user_input,eax
	cmp eax,comp_number
	je say_bye
	call crlf
	inc waiting_number
	jmp loop_check

keep_line:
	mov user_input, eax
	cmp eax, comp_number
	je say_bye
	jmp loop_check

loop_check:
	loop isComposites

say_bye:
	call Crlf
	ret
showComposities ENDP


; ------------------------------------------------
; prpcedure: check_prime_number(check the number is prime number)
; receives: waiting from showComposities function
; returns: true or false
; preconditions: the number can be divided from 2- number
; registers changed : eax
; ------------------------------------------------


check_prime_number PROC 

	mov eax,2
	mov Div_number, eax									;assign the first divided number is 2

check_number:
	mov eax, waiting_number								;waiting_number / Div_number, check the number is 0 or not
	mov ebx,Div_number
	div ebx
	cmp edx,0
	je not_prime_number									;if the number isn 
	jne next_number										;if not prime_number


next_number:
	inc Div_number
	mov Div_number,eax
	cmp eax,waiting_number
	je not_prime_number
	jmp check_number




is_prime_number:
	mov bool_function,0
	jmp break_program

not_prime_number:
	mov bool_function,1
	jmp break_program


break_program:
	call Crlf
	
	ret
check_prime_number ENDP



; ------------------------------------------------
; prpcedure: goodbye(show same amount of composities number)
; receives: Endmessage_1 is valiable
; returns: no return
; preconditions: after finishing number print
; registers changed :none
; ------------------------------------------------

goodbye PROC

	mov		edx, OFFSET Endmessage_1					;output the ending_message
	call	WriteString
	call    Crlf


	ret
goodbye ENDP
END main



