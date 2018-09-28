# Who:  Joshua Chen
# What: Project2.asm
# Why:  Determines the nth term in Fibonacci's Sequence.
# When: Created: 4/30/18	Due: 5/2/18
# How:  
#	$t0 is used to track of the index; a counter variable.
#	$t1 is used to track the greater of two numbers in Fibonacci's sequence.
#	$t2 is used to track the lesser of two numbers in Fibonacci's sequence.
#	$t3 stores the value of n.
#	$t4 is used to keep track of the offset when traversing the array.
#	$t5 stores the value of the nth term in Fibonacci's Sequence.
#	$t6 is used as a temp variable to help with changing the values of $t1 and $t2
#	$t7 is used as a boolean for conditionals.

.data
array:		.word		0:50
promptN:	.asciiz		"Enter the value of n (between 0 and 46): "
invalidN:	.asciiz		"Invalid value for n.\n"
printN:		.asciiz		"The nth term in the Fibonacci's Sequence is: "
sequence:	.asciiz		"Partial Sequence: "
tripleDot:	.asciiz		"..."
addspace:	.asciiz		" "
newLine:	.asciiz		"\n"

.text
.globl main


main:	# program entry
li	$t0, 0				# Counter (count = 0)
li	$t1, 0				# Current Fibonacci Number if n < 2	(num1 = 0)
li	$t2, 0				# Current Fibonacci Number if n >= 2	(num2 = 0)

initializeN:
	li	$v0, 4
	la	$a0, promptN
	syscall
	li	$v0, 5
	syscall
	move	$t3, $v0		# Store n in $t3
	
	beq 	$t3, 46, endInput	# If n == 46
	
	slti	$t7, $t3, 46		# $t7 =  n < 46
	slt	$t8, $zero, $t3		# $t8 =  0 < n
	and	$t7, $t7, $t8		# $t7 = (n < 46) && (0 < n)
	beq	$t7, 1, endInput	# if $t7 == 1
	
	li	$v0, 4
	la	$a0, invalidN
	syscall
	j	initializeN
	
endInput:	

li	$v0, 4				# Print String
la	$a0, newLine
syscall	

addi	$t3, $t3, 1			# Add 1 to n for easier looping
	
Loop:
	slt	$t7, $t0, $t3		# $t7 = 1 if count < (n + 1)
	bne	$t7, 1, EndLoop		# if $t7 != 1, branch to EndLoop
	
	sll	$t4, $t0, 2		# $t4 is the offset for the array. $t4 = $t0 * 2
	
	slti	$t7, $t0, 2		# $t7 = 1 if count < 2
	beq	$t7, 1, FirstTwoFib	# if (count < 2), branch to FirstTwoFib
	beq	$t7, 0, Fibonacci	# if (count >= 2), branch to Fibonacci
	
FirstTwoFib:
	move	$t5, $t1		# $t5 holds the nth Fibonacci number when (n < 2)
	sw	$t5, array($t4)		# Store the current Fibonacci number into the correct array index
	
	move	$t2, $t1		# num2 = num1
	addiu	$t1, $t1, 1		# num1++
	addiu	$t0, $t0, 1		# count++
	
	j	Loop

Fibonacci:
	addu	$t5, $t2, $zero		# $t5 holds the nth Fibonacci number when (n >= 2)
	sw	$t5, array($t4)		# Store the current Fibonacci number into the correct array index
	
	addu 	$t6, $t1, $zero		# temp = num1
	addu	$t1, $t1, $t2		# num1 = num1 + num2
	addu	$t2, $t6, $zero		# num2 = temp
	addiu	$t0, $t0, 1		# count++
	
	j	Loop
	
EndLoop:

li	$v0, 4				# Print String
la	$a0, printN
syscall	

li	$v0, 1				# Print Integer
move	$a0, $t5
syscall

li	$t0, 0

li	$v0, 4				# Print String
la	$a0, newLine
syscall	

la	$a0, sequence
syscall

DisplayPartialSequence:
	slti	$t7, $t0, 10
	beq	$t0, $t3, Exit		# If count = n, no more values to display
	beq 	$t7, 0, Exit		# If the value at $t0 is 80 (20 words)
	
	sll	$t4, $t0, 2
	
	lw 	$t7, array($t4)		# Load word at the current index into $t1
	li	$v0, 1			# $v0 = print integer
	move	$a0, $t7		# $a0 = value at $t1
	syscall				# Print integer
	
	li	$v0, 4			# $v0 = Print String
	la	$a0, addspace		# Spaces between each value
	syscall
	
	add	$t0, $t0, 1		# Move $t0 4 bits
	j	DisplayPartialSequence
Exit:
li	$v0, 4				# Print String
la	$a0, tripleDot
syscall	

li 	$v0, 10				# terminate the program
syscall
