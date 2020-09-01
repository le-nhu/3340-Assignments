#Nhu Le
#CS 3340.005
#The program uses a non-recursive merge sort which uses a list of int from user input
#After going thru the merge repeatedly, list should be sorted in both "user" and "list" data, and shall be output to screen
	.data
user: .space 128
list: .space 128
promptsize: .asciiz "Enter list size with a power of 2. (2,4,8,16, or 32)\n"
promptlist: .asciiz "Enter a number.\n"
error: .asciiz "List size enter is not power of 2.\n"
separate: .asciiz " " 

	.text
	.globl main
main:
	li $v0, 4
	la $a0, promptsize
	syscall
	li $v0, 5
	syscall
	move $t0, $v0	    #t0 contains the size of the list
	li $t1, 0			#t1 represents the time user inputs into the list
	la $s1, user
	
checkpower:				#check if size is power of 2
	li $t7, 2
	move $t9, $t0
	div $t9, $t7
	mfhi $t3
	bne $t3, 0, invalidlist
	j inputloop
	
invalidlist:			#restart from main to get new input for user list
	li $v0, 4
	la $a0, error
	syscall
	j main
	
inputloop:
	bge $t1, $t0, setup
	li $v0, 4
	la $a0, promptlist
	syscall
	li $v0, 5
	syscall
	sw $v0, 0($s1)		#store the input
	addi $t1, $t1, 1
	addi $s1, $s1, 4
	j inputloop

setup:
	la $s2, user
	la $s3, list
	li $t1, 1 		#size
	li $t2, 0		#increment
	jal merge
	jal print

merge: 
	add $sp, $sp, -4
    sw $ra, 0($sp)
	bge $t1, $t0, endmerge
	li $t5, 0		#low1
	li $t4, 0		#use to increment to go through element of list[] 

while: #l1+size < n
	add $t9, $t5, $t1
	bge $t9, $t0, f1
	li $t6 , 1			#h1 = l1 + size -1, high1
	sub $t6, $t1, $t6
	add $t6, $t5, $t6
	li $t7, 1			#l2 = h1 + 1, low2
	add $t7, $t6, $t7
	li $t8 , 1			#h2 = l2 + size -1, high2
	sub $t8, $t1, $t8
	add $t8, $t7, $t8
	blt $t8, $t0, cont
	
if: #h2>=n
	li $t8, 1
	sub $t8, $t0, 1
	
cont:	
	move $t2, $t5		#use to increment to go through element of list/user
	move $t3, $t7		#use to increment to go through element of user[]
	
while2: #i<=h1 && j<=h2
	bgt $t2, $t6, initi
	bgt $t3, $t8, initi
	move $s4, $t2	#getting index of element at user[i]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s2
	lw $s6, 0($s5)	#placed value of user[i] into $s6
	move $s4, $t3	#getting index of element at user[j]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s2
	lw $s7, 0($s5)	#placed value of user[j] into $s7
	ble $s6, $s7, while2if

while2else:	#user[i] > user[j]
	move $s4, $t4
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s8, $s4, $s3
	sw $s7, 0($s8)		#save content of user[j] into list[k]
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	b while2
	
while2if: #useri] <= user[j]
	move $s4, $t4
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s8, $s4, $s3
	sw $s6, 0($s8)		#save content of user[i] into list[k]
	addi $t4, $t4, 1
	addi $t2, $t2, 1
	b while2

initi:
	move $s4, $t2	#getting index of element at user[i]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s2
	lw $s6, 0($s5)	#placed value of user[i] into $s6
	b while3
	
initj:
	move $s4, $t3	#getting index of element at user[j]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s2
	lw $s7, 0($s5)	#placed value of user[j] into $s7
	b while4
	
while3: #i<=h1
	bgt $t2, $t6, initj
	move $s4, $t4
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s8, $s4, $s3
	sw $s6, 0($s8)		#save content of user[i] into list[k]
	addi $t4, $t4, 1
	addi $t2, $t2, 1
	b initi
	
while4: #j<=h2
	bgt $t3, $t8, loopwhile
	move $s4, $t4
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s0, $s4, $s3
	sw $s7, 0($s0)		#save content of user[j] into list[k]
	addi $t3, $t3, 1
	addi $t4, $t4, 1
	b initj
	
loopwhile:
	li $s4, 1
	add $t5, $t8, $s4
	b while

i:
	move $s4, $t2	#getting index of element at list[i]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s2
	lw $s6, 0($s5)	#placed value of list[i] into $s6
	b for1con

f1: #reinitilize i to be i=l1
	move $t2, $t5
	
for1con: #save remaining element left
	bge $t4, $t0, f2
	move $s4, $t4
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s8, $s4, $s3
	sw $s6, 0($s8)		#save content of list[k] into user[i]
	addi $t4, $t4, 1
	addi $t2, $t2, 1
	b i

f2: #reinitiza i = 0
	li $t2, 0
	
temp1:
	move $s4, $t2	#getting index of element at list[i]
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s5, $s4, $s3
	lw $a3, 0($s5)	#placed value of list[i] into $a3
	b for2
	
for2:
	bge $t2, $t0, double
	move $s4, $t2
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $s0, $s4, $s2
	sw $a3, 0($s0)		#save content of user[i] into list[i]
	addi $t2, $t2, 1
	b temp1

double: #double the size and recall merge
	li $s4, 2
	mul $t1, $t1, $s4
	b merge
	
endmerge:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
print:
	la $t4, list
	li $t3, 1 #set loop counter to print list
	
printlist:
	bgt $t3,$t0, fin
	lw $a0, ($t4)
    li $v0, 1
    syscall                                 
	li $v0, 4
	la $a0, separate
	syscall
    addi $t4, $t4, 4   
    addi $t3, $t3, 1                       
    j printlist
	
fin:
	li	$v0, 10			  
	syscall