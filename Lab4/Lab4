#######################################################################################################
# Created by:	Revino, Jake
#              jrevino
#            30 November 2020
#
# Assignment: Lab 4: Searching HEX
#                    CSE 12L, Computer Systems and Assembly Language
#                    UC Santa Cruz, Fall 2020
#
# Description: This program takes in up to 8 hex inputs,
#              converts them to their decimal values and computes the maximum
# Notes: This program is intended to be run from MARS IDE
#######################################################################################################


.data
	args: .asciiz "\nProgram arguments:\n"
         space: .asciiz " " 
         d_rep: .asciiz "\nInteger values:\n"
         newLine: .asciiz "\n"
         maxVal: .asciiz "Maximum value:\n"
.text
main:


    add $s1, $zero, $a1              # store adress of arguments in s1
    add $s5, $zero, $a1              # store adress of arguments in s5
    add $s2, $zero, $a0              # store number of arguments into s2
    addi $s3, $zero, 0               # s3 = 0 for a loop counter
    addi $t9, $zero, 0               # this will be used for printing
    addi $t7, $zero, 0               # this will be used for maxValue
    addi $s7, $zero, 0               # this will be used for print loop

    la $a0, args   		 # load and print "Program arguments" string
    li $v0, 4                     # print
    syscall
    
printloop:                       
    beq $s7, $s2, resetValues     # only print as many times as there are args
    lw $a0, 0($a1)                # get the first word
    li $v0, 4                     # print
    syscall
    
    la $a0, space                 # print a space between words
    li $v0, 4                     # print
    syscall
    
    addi $a1, $a1, 4              # increment to next word
    addi $s7, $s7, 1              # increment printloop counter
    j printloop                   # loop again if there are more ar

resetValues:                      # print stuff and put s7 back to 0
    la $a0, newLine               # print new line
    li $v0, 4                  
    syscall
    
    la $a0, d_rep                # print "Decimal representation" string
    li $v0, 4
    syscall
    
    sub $s7, $s7, $s7            # return s7 to 0 to be reused   
    
whileMAIN:
     
    beq $s7, $s2, done           # only loop for the amount of arguments
                                 # s7=0 < numArgs
    lw $s4, ($s1)                # load whole word onto s4
       
while:    
    lbu $t1, 2($s4)              # skip "0x" part
    beq $t1, $zero, gotLength    # if $zero, then end of word
    addi $s3, $s3, 1             # increment counter to find length
    addi $s4, $s4, 1             # increment position to traverse word
    j while                      # do it again
    
gotLength:                        
   beq $s3, 3, multHigh          # if length = 3, do operations for 3 characters
   beq $s3, 2, multMid           # if length = 2, do operations for 2 characters
   beq $s3, 1, multLow           # if length = 2, do operations for 2 characters
 
###################### THIS IS IF length = 3 ######################## 
multHigh:
    lw $s6, ($s5)                # load word onto s6
    lbu $t3, 2($s6)              # load value of first position after "0x"
    blt $t3, 65, convNumHIGH_t3  # check if its a number or letter
    subi $t3, $t3, 55            # subtract 55 for capitol letter
    sll $t3, $t3, 8              # ssl by 8 == multiply by 16^2
    
nextLetter: 
    lbu $t4, 3($s6)              # load the value at next position to t4
    blt $t4, 65, convNumHIGH_t4  # check if its number or letter
    subi $t4, $t4, 55            # subtract 55 for letter
    sll $t4, $t4, 4              # ssl by 4 == multiply by 16
    
lastLetter:
    lbu $t5, 4($s6)              # load last character onto t5
    blt $t5, 65, convNumHIGH_t5  # check if letter or number
    subi $t5, $t5, 55            # subtract 55 for letter
    j printHIGH                  # time to go print these

convNumHIGH_t3:
    subi $t3, $t3, 48            # subtract 48 for number
    sll $t3, $t3, 8              # sll by 8 == multiply by 16^2
    j nextLetter                 # return to work the next value

convNumHIGH_t4:
    subi $t4, $t4, 48            # subtract 48 for number     
    sll $t4, $t4, 4              # sll by 4 == multiply by 16
    j lastLetter                 # return to handle last value

convNumHIGH_t5:
    subi $t5, $t5, 48            # subtract 48 but don't multiply
    j printHIGH                  # b/c this would be 16^0 == 1
  
################  PRINTING WHEN LENGTH = 3  ##################      
printHIGH:
    add $t4, $t4, $t3            # add up calculated values 1 & 2
    add $t9, $t5, $t4            # add up all 3 calculated values
    move $a0, $t9                # print out the total calculated value 
    li $v0, 1                    # syscall 1 for print integer
    syscall
    
    la $a0, space                # print out a space between values
    li $v0, 4                    
    syscall
    
    addi $s1, $s1, 4             # increment adress to next word
    addi $s5, $s5, 4             # increment adress to next word
    addi $s7, $s7, 1             # increment loop counter
    sub $s3, $s3, $s3            # return length back to 0 for next arg
    ble $t7, $t9, newMaxHIGH     # check for new max value
    j whileMAIN                  # return for next iteration

newMaxHIGH:                      # new maximum found so save it
    add $t7, $zero, $t9
    j whileMAIN
    
###################### PRINTING IF LENGTH = 2 #####################    
printMID:
    add $t9, $t3, $t4            # add up calculated values
    move $a0, $t9                # move to printing position
    li $v0, 1                    # syscall 1 to print int
    syscall
    
    la $a0, space                # print space between values
    li $v0, 4
    syscall
    
     addi $s1, $s1, 4            # increment to next arg
     addi $s5, $s5, 4            # increment to next arg
     addi $s7, $s7, 1            # increment loop counter
     sub $s3, $s3, $s3           # return length back to 0
     ble $t7, $t9, newMaxMID     # check for a new max value
     j whileMAIN                 # return for next iteration

newMaxMID:
    add $t7, $zero, $t9          # new max found so save it
    j whileMAIN                  # return for next iteration
   
##################### PRINTING IF LENGTH = 1 #########################
printLOW:
    move $a0, $t3                # move calculated value to printing position
    li $v0, 1                    # syscall 1 for int
    syscall
    
    la $a0, space                # print a space between values
    li $v0, 4
    syscall
    
     addi $s1, $s1, 4            # increment args to next word
     addi $s5, $s5, 4            # increment args to next wo
     addi $s7, $s7, 1            # increment loop counter
     sub $s3, $s3, $s3           # return length back to 0
     ble $t7, $t3, newMaxLOW     # check for new max value
     j whileMAIN                 # return for next iteration

newMaxLOW:
    add $t7, $zero, $t3          # new max found so save it
    j whileMAIN                  # return for next iteration
    
#################### CALCULATIONS FOR WHEN LENGTH = 2 ############
multMid:
    lw $s6, ($s5)                # load word onto s6
    lbu $t3, 2($s6)              # load value after "0x"
    blt $t3, 65, convNumMID_t3   # check if number or letter
    subi $t3, $t3, 55            # subtract 55 for letter
    sll $t3, $t3, 4              # sll by 4 == multiply by 16
    
nextLetterMID: 
    lbu $t4, 3($s6)              # load value at next position
    blt $t4, 65, convNumMID_t4   # check if number or letter
    subi $t4, $t4, 55            # subtract 55 for letter
    j printMID                   # time to go print
    
convNumMID_t3:
    subi $t3, $t3, 48            # value was a number so subtract 48
    sll $t3, $t3, 4              # multiply by 16
    j nextLetterMID              # return to get the next value

convNumMID_t4:
    subi $t4, $t4, 48            # subtract 48 for number but don't multiply
    j printMID                   # time to go print

################# CALCULATIONS FOR WHEN LENGTH = 1 ###############
multLow:
    lw $s6, ($s5)                # load adress of word onto s6
    lbu $t3, 2($s6)              # load value at position past "0x"
    blt $t3, 65, convNumLOW_t3   # check if number or letter
    subi $t3, $t3, 55            # subtract 55 for letter
    j printLOW                   # time to go print

convNumLOW_t3:
     subi $t3, $t3, 48           # was a number so subtract 48
     j printLOW                  # go print
    
done:                            # loop counter (s7) == numArgs(s2)
    la $a0, newLine              # print out a new line
    li $v0, 4       
    syscall
    
    la $a0, newLine              # one more new line
    li $v0, 4
    syscall
    
    la $a0, maxVal               # print out "Maximum value:" string
    li $v0, 4
    syscall
    
    move $a0, $t7                # print out the maximum value
    li $v0, 1
    syscall
    
    la $a0, newLine              # print out another new line
    li $v0, 4
    syscall
    
    li $v0, 10                   # end program
    syscall
    
    
    
    
