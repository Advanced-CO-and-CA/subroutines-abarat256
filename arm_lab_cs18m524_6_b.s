/******************************************************************************
* file: arm_lab_cs18m524_assignment_6_b.s
* author: Ananya Barat
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

@ BSS section
      .bss	  

 
 
@ TEXT section
      .text
	  
/* Algorithm
*  1. Read #elements from the keyboard/stdin
*  2. Read elements of the array from the keyboard and store them in memory.
*  3. Read the search element from the keyboard/stdin. The element MUST be in sorted order.
*  4. Do Binary search n the sorted array.
*  5. Store first position of the array in a register and final position in another.
*  6. Calculate the middle position as (first+last)/2 
*  7. Traverse and access the element in the middle position
*  8. If the search element is greater than the element jump to greater and update first position as mid +1
*  9. If the search element is lesser than the element jump to lesser and update the last position as mid -1
*  10. If the search element matches the middle element then element is found so return position.
*  11. Stop if first position value > last position value.
*  12. Return -1 if the element was still not found. */
	 

.globl _main
	

		mov r0, #1					@to display on stdout
		ldr r1 , =InputNum			@loading the message
		swi 0x69					@displaying it
		mov r0,#0        
		ldr r1, =InputFileHandle    @to take input from keyboard/stdin   			  
		swi 0x6c               		@taking the input with interrupt
		mov r4, r0 					@storing number of elements in r4
		
		mov r0, #1					@asking user to input array elements
		ldr r1 , =InputElem
		swi 0x69
		mov r6, #1
		ldr r3, =ArrayStore
	
loop:	
		mov r0,#0        			@taking all array elements as input
		ldr r1, =InputFileHandle       			  
		swi 0x6c 
		str r0, [r3]				@storing every array element in contiguous memory 
		ldr r5, [r3], #4
		add r6, #1
		cmp r6, r4
		ble loop
		
		mov r0, #1
		ldr r1 , =SearchElem
		swi 0x69					@asking user to input the search element
		mov r0,#0        
		ldr r1, =InputFileHandle       			  
		swi 0x6c               
		mov r9, r0					@accepting the search element as input from stdin
		mov r6, #1					@r6 will store the search element
		
/* Searching with binary search logic. If #elements = n #searches = log n */
		
Bsearch:
		cmp r6, r4					@Checking if first position has a greater value than the last position
		bgt NotFound				@If we reached here element is not in the array so jump to not found.
		ldr r3, =ArrayStore
		add r7, r6, r4				@mid = (first + last)/2
		mov r7, r7, lsr#1
		mov r8 , #0					@counter to traverse to the middle element
		
loop1:  
		ldr r5, [r3] , #4			@traversing to the mid element
		add r8 , #1
		cmp r8 , r7
		beq Check
		B loop1

Check:
		cmp r9, r5					@if search element < mid element go to Lesser 
		blt Lesser
		cmp r9, r5
		bgt Greater					@if search element > mid element go to Greater
		B Output

Lesser:
	    sub r4, r7, #1				@If search elemnt is lesser only look at the first half of the array. So last = mid -1
		B Bsearch

Greater:
		add r6, r7 , #1				@If search elemnt is greater only look at the second half of the array. So first = mid +1
		B Bsearch

NotFound: 
		mov r7 , #-1				@If not found we need to ret
		B Output

Output:
		mov r0, #1					@Print the returned position to the console
		ldr r1 , =OutPutMsg
		swi 0x69
		mov r1, r7
		mov r0 , #0             
		ldr R2, =OutputFileHandle                    
		swi 0x6b 
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
		