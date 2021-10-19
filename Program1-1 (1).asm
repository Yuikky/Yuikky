; Author: Jingwei Geng.
; Course number / section:CS_271_001_U2020
; Project ID : Program#1						Due date : Jul 5 by 11 : 59pm
;Description:
; Display your name and program title on the output screen.
;	Display instructions for the user.
;		Prompt the user to enter two numbers.
;		Calculate the sum, difference, product, (integer)quotient and remainder of the numbers.
;		Display a terminating message.
;
; **EC:Validate the second number to be less than the first.
; **EC:Display the square of each number.

INCLUDE Irvine32.inc



.data

Info_1			    BYTE "Elementary Arithmetic by Jingwei Geng", 0
Info_2				BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
Extra_Credit_1		BYTE "**EC:Validate the second number to be less than the first.",0
Extra_Credit_2		BYTE "**EC:Display the square of each number.",0
input_Number1		BYTE "First number:", 0
input_Number2		BYTE "Second number:", 0
remaider_message	BYTE " remaider  ",0
error_info			BYTE " The second number must be less than the first!",0
square_info			BYTE "Square of ",0

Number_1			DWORD ?
Number_2			DWORD ?
Find_remainder		DWORD ?
error_check			DWORD ?

Sum_result			DWORD ?
Sub_result			DWORD ?
Muti_result			 DWORD ?
Div_result			DWORD ?
remainder_result    DWORD ?
square1_result		DWORD ?
square2_result		DWORD ?

Sum_char			BYTE " + ", 0
Sub_char			BYTE " - ", 0
muti_char			BYTE " x ", 0
div_char			BYTE " / ", 0
equal_char			BYTE " = ", 0
End_message			BYTE "Impressed? Bye!", 0





.code
main PROC
; *************Introduce**********
Intro_parts:
mov		edx, OFFSET Info_1
call  WriteString
call  CrLf
call  CrLf
mov		edx, OFFSET Extra_Credit_1
call Writestring
call  CrLf
call  CrLf
mov		edx, OFFSET Extra_Credit_2
call Writestring
call  CrLf
call  CrLf
mov		edx, OFFSET Info_2
call  WriteString
call  CrLf
call  CrLf

; *************get user number 1 and 2 * *********
mov		edx, OFFSET input_Number1
call Writestring
call ReadInt
mov	Number_1, eax
call Crlf
mov		edx, OFFSET input_Number2
call Writestring
call ReadInt
mov	Number_2, eax
call Crlf


; ************Error_check****************
mov eax, Number_1
sub eax, Number_2
mov error_check, eax
; find the sub result of number 1 amd 2, if the result less or equal 0
; jump to error_message parts, if not jump to calculate parts

cmp eax, 0

; less or equal 0, will jump to error message parts
jle error_message

;if not, jump to calculate parts
jg Calculate_result

error_message :
; typing error check parts at there, once the number1 < number2.
	; and jump to ending

mov         edx, OFFSET error_info
call  WriteString
call  CrLf
; jmp to Ending parts whatever, if not jump to ending,
; the program will exeuate the calculate parts
jmp Ending


Calculate_result:
; ***********sum**************
; use sum to find the result
mov eax, Number_1
add eax, Number_2
mov Sum_result, eax

; ***********sub**************
; use sub to find the result
mov eax, Number_1
sub eax, Number_2
mov Sub_result, eax

; ***********mul**************
;; use mul to find the result
mov eax, Number_1
mov ebx, Number_2
mul ebx
mov muti_result, eax

; ***********Div**************
;use div to find the result
mov eax, Number_1
mov ebx, Number_2
div ebx
mov Div_result, eax

; ***********remainder**************
; use simple math way to find the remainder
mov eax, Number_2
mov ebx, Div_result
mul ebx
mov Find_remainder, eax
mov eax, Number_1
sub eax, Find_remainder
mov remainder_result, eax


; ***********Square1**************
;call number 1 twice to find the square
mov eax, Number_1
mov ebx, Number_1
mul ebx
mov square1_result, eax

; ***********Square2**************
mov eax, Number_2
mov ebx, Number_2
mul ebx
mov square2_result, eax



Print_result :

; ***************Sum******************

mov eax, Number_1
call WriteDec
mov edx, OFFSET Sum_char
call WriteString
mov eax, Number_2
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, Sum_result
call  WriteDec
call Crlf


; ***************Sub******************

mov eax, Number_1
call WriteDec
mov edx, OFFSET Sub_char
call WriteString
mov eax, Number_2
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, Sub_result
call  WriteDec
call Crlf

; ***************Muti******************

mov eax, Number_1
call WriteDec
mov edx, OFFSET muti_char
call WriteString
mov eax, Number_2
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, muti_result
call WriteDec
call Crlf

; ***************Divide******************
mov eax, Number_1
call WriteDec
mov edx, OFFSET div_char
call WriteString
mov eax, Number_2
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, Div_result
call  WriteDec

; ***************Ramainder******************
mov edx, OFFSET remaider_message
call WriteString
mov eax, remainder_result
call  WriteDec
call Crlf



;***************SquareofNumber1******************
mov edx, OFFSET square_info
call WriteString
mov eax, Number_1
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, square1_result
call  WriteDec
call Crlf

; ***************SquareofNumber2******************
mov edx, OFFSET square_info
call WriteString
mov eax, Number_2
call WriteDec
mov edx, OFFSET equal_char
call WriteString
mov eax, square2_result
call  WriteDec
call Crlf


Ending:
mov edx, OFFSET End_message
call  WriteString
call  CrLf

exit
main ENDP
END main







