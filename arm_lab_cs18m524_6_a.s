/******************************************************************************
* file: arm_lab_cs18m524_assignment_6_a.s
* author: Ananya Barat
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

@ BSS section
      .bss	  

/* Algorithm
*  1. Read #elements from the keyboard/stdin
*  2. Read elements of the array from the keyboard and store them in memory.
*  3. Read the search element from the keyboard/stdin.
*  4. Pass the array and the search element as parameters through registers and a block of memory to the subroutine.
*  5. In the subroutine, traverse throught the array to get the search element.
*  6. Return position of element or -1 if not present , from the subroutine.
*  7. Display the returned value on stdout through an interrupt. */

 
 
@ TEXT section
      .text
	 

.globl _main
	

		mov r0, #1            	   @to display on stdout
		ldr r1 , =InputNum	  	   @loading the message
		swi 0x69			  	   @displaying it
		
		mov r0,#0        
		ldr r1, =InputFileHandle   @to take input from keyboard/stdin		  
		swi 0x6c                   @taking the input with interrupt
		mov r4, r0				   @storing number of elements in r4
		
		mov r0, #1                 @asking user to input array elements
		ldr r1 , =InputElem
		swi 0x69
		mov r6, #1
		ldr r3, =ArrayStore
	
loop:	
		mov r0,#0                  @taking all array elements as input
		ldr r1, =InputFileHandle       			  
		swi 0x6c 
		str r0, [r3]			   @storing every array element in contiguous memory location for later traversal
		ldr r5, [r3], #4
		add r6, #1
		cmp r6, r4
		ble loop
	
		mov r0, #1				  @asking user to input the search element
		ldr r1 , =SearchElem
		swi 0x69
		mov r0,#0        
		ldr r1, =InputFileHandle       			  
		swi 0x6c                  @accepting the search element as input from stdin
		mov r6, r0				  @r6 will store the search element

/* Parameters have been passed through registers and a block of memory to the subroutine ListSearch */	
	
		ldr r3, =ArrayStore		  @loading the Array start address in r3 to traverse through the array for search
		bl ListSearch             @context switching to the subroutine ListSearch
		mov r0, #1				  @load the descriptor of stdout to display the result
		ldr r1 , =OutPutMsg
		swi 0x69
		mov r1, r7				  @after the execution of the subroutine r7 contains the location of search element or -1
		mov r0 , #0             
		ldr R2, =OutputFileHandle                    
		swi 0x6b    			  @print location of search element or -1
		
		swi 0x11
		
ListSearch:
		stmfd sp!,{r8,lr}	      @saving LR contents on the processor stack
		mov r7 , #1				  @r7 will hold the position of the search element
		
		
loop1: 
		ldr r5, [r3], #4		  @traversing the array
		cmp r6, r5				  
		beq END					  @Checking if search element was found
		add r7, #1				  @Increment the position of the array and check 
		cmp r7 , r4				  @Checking if the end of the array has been reached
		ble loop1				  
		mov r7, #-1				  @If the end of the array was reached and element was not found mov -1 in r1 to indicate not found
		
END: 
		LDMFD sp!,{r8,pc} 		  @context switch back from subroutine to main program
	

exit:
	@end

	
@ DATA SECTION
      .data  

InputFileHandle: .word 0
OutputFileHandle: .word 0 
ArrayStore: .word 0
InputNum: .asciz "\nEnter the number of elements:: "
InputElem: .asciz "\nEnter the elements:: "
SearchElem: .asciz "\nEnter the search Element:: "
OutPutMsg: .asciz "\nThe position of the search element is :: "


.end  
