# Nhu Le
#The program calculates the squared value of the arg and will work if the arg changes to 6,1,0,10,etc.

	.data	
arg:	.word	5
arg2:	.word	5
prompt1: .asciiz "\nEnter a value\n"
prompt2: .asciiz "Enter another value\n"
output: .asciiz "\nFirst value squared is "
output2: .asciiz "\nSecond value squared is "
negative: .asciiz "0"

	.text
	.globl main
main:
	li $v0, 4
	la $a0, prompt1
	syscall
	li $v0,5
	syscall
	move $13, $v0
	move $12, $13
	li $v0,4
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	move $14, $v0
	move $16, $14
	addi $11, $zero, 0
	addi $15, $zero, 0
	bltz $13, negatives
	bltz $14, negatives
	beq $13, $14, same
	bne $13, $14, different
negatives:
	li $v0,4
	la $a0, negative
	syscall
	li $v0, 10
	syscall
same:
	add	$11, $11, $12	  
	addi	$13, $13, -1 
	bnez	$13, same	 
fin:
	li $v0,4
	la $a0, output
	syscall
	li $v0, 1
	move $a0, $11
	syscall
	li $v0,4
	la $a0, output2
	syscall
	li $v0, 1
	move $a0, $11
	syscall
	li	$v0, 10			  
	syscall				  	
different:
	add	$11, $11, $12	 
	addi	$13, $13, -1 
	bnez	$13, different	
different2:
	add	$15, $15, $16	 
	addi	$14, $14, -1  
	bnez	$14, different2	 
findiff:
	li $v0,4
	la $a0, output
	syscall
	li $v0, 1
	move $a0, $11
	syscall
	li $v0,4
	la $a0, output2
	syscall
	li $v0, 1
	move $a0, $15
	syscall
	li	$v0, 10			
	syscall				  
