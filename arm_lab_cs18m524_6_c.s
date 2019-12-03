/******************************************************************************
* file: arm_lab_cs18m524_assignment_6_c.s
* author: Ananya Barat
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

@ BSS section
      .bss	  

 
 
@ TEXT section
      .text
/* Algorithm
* 1. Accept N from the user. The Nth Fibonacci number must be printed.
* 2. If N = 1 or N =2 , print the output as 1 on the stdout.
* 3. Otherwise put the value of N in the registers and pass to the subroutine Fibonacci.
* 4. The contents of the LR are stored in a register. 
* 5. In the subroutine fibonacci generate the fibonacci sequence 1,1,2,3,5,8,13,21,34,55,... 
* 6. Logic for this is to start with a=1, b=1 and then do c = a+b, a=b, b=c.
* 7. So to find fibonacci(n), we have to find fibonacci(1), fibonacci(2), fibonacci(3) ... fibonacci(n-1) and then fibonacci(n)
* 8. The subroutine Fibonacci calls itself and the calls are stored in the stack. */ 
	  
.globl _main

		mov r0, #1					@to display on stdout
		ldr r1 , =InputNum			@loading the message
		swi 0x69					@displaying it
		mov r0,#0        
		ldr r1, =InputFileHandle       			  
		swi 0x6c 					@ask the user to input the value N
		mov r3, r0
		
		mov r4, #1					@first value of series = 1
		mov r5, #1					@Second value of series = 1
		mov r7, #1
		cmp r3, #1
		beq Output					@if N =1 or N=2 Output =1
		cmp r3, #2
		beq Output
		mov r6, #3					@counter to check if we have reached the Nth value
		bl Fibonacci				@if N>2 jump to the subroutine Fibonacci

Fibonacci:
		stmfd sp!,{r8,lr}			@Store the contents of LR in a register
		add r7, r4, r5				@Fn = Fn-1 + Fn-2
		cmp r6, r3					@Check if we have reached the Nth value of the series
		beq Output					@if Nth Value is calclated display it as output
		mov r4, r5					@Update Fn-1 to Fn and Fn-2 to Fn-1
		mov r5, r7					
		add r6, #1 
		bl Fibonacci				@recursively call the same subroutine. This stores function calls in the stack.
		ldmfd sp!,{r8,pc} 			@Restore the PC value

 			 
Output:
		mov r0, #1					@Output the Nth Fibonacci number
		ldr r1 , =OutPutMsg
		swi 0x69
		mov r1, r7
		mov r0 , #0             
		ldr r2, =OutputFileHandle                    
		swi 0x6b 
		@end
				
.data 
	
InputFileHandle: .word 0
InputNum: .asciz "\nEnter the value N ::: "
OutputFileHandle: .word 0 
OutPutMsg: .asciz "\nThe value is :: "
