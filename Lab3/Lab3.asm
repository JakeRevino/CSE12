.data
        prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
        invalid: .asciiz "Invalid Entry!\n"
        asterisk: .asciiz "*"
        tab: .asciiz "\t"
        newline: .asciiz "\n"
.text 
.globl main
main:
        # prompting user for height of patter
        la $a0, prompt
        li $v0, 4
        syscall
        # reading user input
        li $v0, 5
        syscall
        
        # $t0 = 0, we'll compare the user input with this
        addi $t0, $zero, 0
        invalidEntry:
                # if uer input is greater than $t0, input is valid, we'll jumpt to label validEntry
                bgt $v0, $t0, validEntry
                # else input is invalid and following will execute
                # print invalid message
                la $a0, invalid
                li $v0, 4
                syscall
                # prompt user again
                la $a0, prompt
                li $v0, 4
                syscall
                # read user input again
                li $v0, 5
                syscall
                # again check user input
                j invalidEntry

        # if input is valid then, move on
        validEntry:
        
        # transfer user input to $s0, so $s0 = rows
        add $s0, $zero, $v0
        # we'll print the numbers starting from 1, $s1 will hold the numbers to print
        addi $s1, $zero, 1
        # i = 0, used to loop $s0 times
        add $t0, $zero, 1
        loop1:
                # if i > i, exit loop 
                bgt $t0, $s0, exitLoop1
                # else execute following
                # $t1 = j will be used to compare the value for loop2
                addi $t1, $zero, 1
                # $t2 = rows - i
                sub $t2, $s0, $t0
                loop2:
                        # if j > rows - i, exit the loop2
                        bgt $t1, $t2, exitLoop2
                        # else print tabs 
                        la $a0, tab
                        li $v0, 4
                        syscall
                        # increment j, i.e j++;
                        addi $t1, $t1, 1
                        # loop again
                        j loop2
                # when tabs printing finishes
                exitLoop2:
                        # print the number
                        add $a0, $zero, $s1
                        li $v0, 1
                        syscall
                        # increment the number for next iteration
                        addi $s1, $s1, 1
                        # because in first iteration no stars are printed we'll check if 
                        # current iteration is not first
                        addi $t2, $zero, 1      # $t2 = 1
                        # if i = 1, i.e first iteration move to next iteration and print nothing
                        beq $t0, $t2, beforeExit
                        # else, for each line we'll print odd number of stars,staring from 1
                        # to determine odd numbers we'll use 2*i - 3
                        # $t3 used for odd number of iterations
                        add $t3, $zero, $zero
                        # $t4 = i
                        add $t4, $zero, $t0
                        # $t4 = 2*i
                        sll $t4, $t4, 1
                        # $t4 = 2*i - 3
                        sub $t4, $t4, 3
                # loop odd number of times and print stars
                loop3:
                        # looping condition
                        bge $t3, $t4, exitLoop3
                        # first print the tab
                        la $a0, tab
                        li $v0, 4
                        syscall
                        # then print the star
                        la $a0, asterisk
                        li $v0, 4
                        syscall
                        # increment loop counter
                        addi $t3, $t3, 1
                        j loop3
                # when odd number of stars have printed
                exitLoop3:
                        # print one more tab
                        la $a0, tab
                        li $v0, 4
                        syscall
                        # print the next number
                        add $a0, $zero, $s1
                        li $v0, 1
                        syscall
                        # increment the number
                        addi $s1, $s1, 1
        beforeExit:
                # before next iteration of the main loop 
                # print newline
                la $a0, newline
                li $v0, 4
                syscall
                # increment the number
                addi $t0, $t0, 1
                j loop1         
        # finally print one more new line at the end
        exitLoop1:
                la $a0, newline
                li $v0, 4
                syscall
        # exit the program
        li $v0, 10
        syscall