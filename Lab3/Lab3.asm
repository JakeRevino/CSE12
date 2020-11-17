#######################################################################################################
# Created by:	Revino, Jake
#              jrevino
#             16 November 2020
#
# Assignment: Lab 3: Introduction to MIPS
#                    CSE 12L, Computer Systems and Assembly Language
#                    UC Santa Cruz, Fall 2020
#
# Description: This program prints out a triangle with numbers and stars with a user specified height
#
# Notes: This program is intended to be run from MARS IDE
#######################################################################################################

.data
        prompt: .asciiz "Enter the height (must be greater than 0):\t"
        invalid: .asciiz "Invalid Entry!\n"
        stars: .asciiz "*"
        tab: .asciiz "\t"
        newline: .asciiz "\n"
.text

	la $a0, prompt	                     # prompting user for height of patter syscall(4)
	li $v0, 4
	syscall
	li $v0, 5                           # reading user input syscall(5)
	syscall
	addi $t0, $zero, 0                  # $t0 = 0
	
	invalidEntry:
		bgt $v0, $t0, validEntry    # if usr input is greater than $t0, input is valid, we'll jumpt to label validEntry  
		la $a0, invalid             # if not valid, print invalid msg and prompt again
		li $v0, 4
		syscall	
		la $a0, prompt              # re-prompt
		li $v0, 4
		syscall                     # re-read
		li $v0, 5
		syscall                     # re-check
		j invalidEntry
	validEntry: 
		add $s0, $zero, $v0         # get height from user input
		addi $s1, $zero, 1          # these'll be the numbers to print >= 1
		add $t0, $zero, 1           # initialize variable t0 = i, starts at 1 for loop
	loop1:
		
		bgt $t0, $s0, exitLoop1     # if t0 > s0
		addi $t1, $zero, 1          # t1 = j, starting at 1
		sub $t2, $s0, $t0           # t2 = height - i
	loop2:
		bgt $t1, $t2, exitLoop2     # if t1 > t2, exit
		la $a0, tab                 # else print tabs
		li $v0, 4
		syscall
		addi $t1, $t1, 1            # j++ / t1++
		j loop2                     # loop again
		                            # once t1 !> t2, loop will end
	exitLoop2:
		add $a0, $zero, $s1         # print number
		li $v0, 1
		syscall
		addi $s1, $s1, 1            # increment
		addi $t2, $zero, 1          # $t2 = 1
		beq $t0, $t2, beforeExit    # if (t0)i == 1, print number and go to next line
		add $t3, $zero, $zero       # else ya need to print correct amount of stars
		add $t4, $zero, $t0         # t4 = i
		sll $t4, $t4, 1             # t4 = 2*i
		sub $t4, $t4, 3             # t4 = 2*i - 3
	loop3:
		bge $t3, $t4, exitLoop3     # if t3 >= t4 - exit
		la $a0, tab                 # else print tabs
		li $v0, 4
		syscall
		la $a0, stars               # print stars
		li $v0, 4
		syscall
		addi $t3, $t3, 1            # increment t3
		j loop3                     # loop again
	exitLoop3:
		la $a0, tab                 # one more tab after the stars
		li $v0, 4
		syscall
		add $a0, $zero, $s1         # print next number
		li $v0, 1
		syscall
		addi $s1, $s1, 1            # increment s1
	beforeExit:
		la $a0, newline             # it was a 1 so go to next line before next iteration
		li $v0, 4
		syscall
		addi $t0, $t0, 1            # increment t0
		j loop1                     # Then go back for next iteration
	exitLoop1:
		la $a0, newline             # print a new line at the end
		li $v0, 4
		syscall        
		li $v0, 10                  # exit
		syscall
		
		
