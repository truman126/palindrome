		AREA prog, CODE, READONLY
		ENTRY
		
							;load the string
		LDR r0, =STRING 	;load the location of the string into r0
	 	LDR r1, =EoS		;load the location of the end of the string into r1
		
							;get the size of the string
SIZE	SUBS r2, r1, r0		;subtract the location of the EoS by the 
							;BMI PAL ;if the string might not need this

		SUB r1, #1 			;set the pointer to the last location of the string by subtracing the EoS by 1
	
COMPARE	SUBS r3,r4 			;compare character one and character two. will compare 0x00 and 0x00 on the first iteration
		BNE NOTPAL 			;if the comparison  is not equal, it is not a palindrome
							;no characters will be evaluated on the first run so it wont trigger the not equal
		
		
		CMP r2, #0  		;this checks if the string length counter in r2 is less than zero
		BMI PAL				;if it has reached the end of string and hasnt been evaluated as not pal, it is therefore a pal


							;to get the first char to evaluate
CHAR1	LDRB r3, [r0], #1 	;load the first char at location pointed by r0, then increment the location by 1
		SUB r2, #1 			;remove from the length, to know when the string is done
		
							;check validation
		CMP r3, #"A" 		;if the string is less than A, it is not a letter
		BLT CHAR1  			;gets a new character to replace the invalid one
		
							;if the letter is less than Z, by now it is greater than A but it needs
		CMP r3, #"Z" 		; to be lowercased so it can be evaluated
		ADDLT r3, r3, #32 	;32 is added to the uppercase value to get the lowercase equivalent
		
		CMP r3, #"a" 		;if the value is still less than a, a new char is needed
		BLT CHAR1 			;a new char is fetched
		
		CMP r3, #"z" 		;if the value is greater than z, a new char is needed
		BGT CHAR1 			;a new char is fetched
		
			
			
		
							;a function to find the second char  to be compared
CHAR2 	LDRB r4, [r1], #-1 	;load the second char and then increment the second counter back to point to the next character for when that is needed
		SUB r2, #1 			;de increment the length of the string
		
							;validate the character
		CMP r4, #"A"		;if the string is less than A, it is not a letter
		BLT CHAR2  			;gets a new character to replace the invalid one
		
		CMP r4, #"Z"		;if the letter is less than Z, by now it is greater than A but it needs
		ADDLT r4, r4, #32	;32 is added to the uppercase value to get the lowercase equivalent
		
		CMP r4, #"a"		;if the value is still less than a, a new char is needed
		BLT CHAR2			;a new char is fetched
		
		CMP r4, #"z"		;if the value is greater than z, a new char is needed
		BGT CHAR2			;a new char is fetched
		
		
		BAL COMPARE			;this loops back and compares the two chars that have been fetched
	 

							;return values
NOTPAL	MOV r0, #0 			;if at any point the program detects two characters are not the same it will store 0 in r0 and exit
		B HALT				;exits the program
	
PAL 	MOV	r0, #1 			;stores a 1 in r0 if it is a palindrome

	 
STRING	DCB "noon" 			;the string to be evaluated

EoS		DCB 0x00 			;end of string s
HALT	NOP					;exit point
		END					;end of program