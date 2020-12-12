#######################################################################################################
# Created by:   Revino, Jake
#                 jrevino
#                 11 December 2020
#
# Assignment: Lab 5:Graphics 
#                    CSE 12L, Computer Systems and Assembly Language
#                    UC Santa Cruz, Fall 2020
#
# Description: This program displays output to MARS' built in bitmap display,
#              
# Notes: This program is intended to be run from MARS IDE AND ran with a test file
#######################################################################################################

#Fall 2020 CSE12 Lab5 Template File

## Macro that stores the value in %reg on the stack 
##  and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# this function does the converting from x,y coordinates to the bitmap coordinates
# inputs: reg_1 = 0x000000XX, reg2 = 0x000000YY
.macro bitCoordinates(%reg_1 %reg_2)
    sll %reg_2, %reg_2, 9            # sll by 9 <==> multiply by 2^9
    sll %reg_1, %reg_1, 2            # multiply by 4, to make a complete word
    add %reg_1, %reg_1, %reg_2       # add reg1 and reg2 put result in reg1
    addi %reg_1, %reg_1, 0xFFFF0000  # adding from original starting point
.end_macro

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
    and %y, %input, 0x0000ffff          # mask input with
    move %x, %input                     # move input to x
    srl %x, %x, 16                      # shift result to right by 4 bits
   
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
    move %output, %x                   # move x into output
    sll %output, %output, 16           # sll by 16
    or %output, %output, %y        
.end_macro 

.data
originAddress: .word 0xFFFF0000

.text
j done
    
done: nop
	li $v0 10 
	syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
clear_bitmap: nop
        add $t0, $zero, $a0        # store args in t0
        addi $t2, $zero, 0         # loop counter
        la $t3, 0xFFFF0000         # beginning of bitmap
     dew_it:
         beq $t3, $t2, exit        # if loopcounter = numPixels, exit
         sw $t0, ($t3)             # sw into bitmap
         addi $t3, $t3, 4          # increment t3
         b dew_it                  # again
     exit:
 	jr $ra

#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
draw_pixel: nop
    getCoordinates($a0 $t0 $t7) # input = a0, t0 = x-coord, t7 = y-coord
    bitCoordinates($t0 $t7)     # put (x,y) into bitmapping position
    sw $a1, ($t0)               # store color into position
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
     getCoordinates($a0 $t0 $t7)    # input = a0, t0 = x-coord, t7 = y-coord
     bitCoordinates($t0 $t7)        # put (x,y) into bitmapping position
  
    lw $v0, ($t0)                   # return color of t7 into v0
	jr $ra

#*****************************************************
#draw_rect: Draws a rectangle on the bitmap display.
#	Inputs:
#		$a0 = coordinates of top left pixel in format (0x00XX00YY)
#		$a1 = width and height of rectangle in format (0x00WW00HH)
#		$a2 = color in format (0x00RRGGBB) 
#	Outputs:
#		No register outputs
#*****************************************************
draw_rect: nop
    getCoordinates($a0 $t0 $t1)     # input = a0, t0 = x-coord, t1 = y-coord
    bitCoordinates($t0 $t1)         # put (x,y) into bitmapping position
    getCoordinates($a1 $t2 $t3)     # input a1 has length and height of rect
    addi $t4, $zero, 0              # t4 = i for loop
    addi $t5, $zero, 0              # t5 = j for loop
for:
    move $t9, $t0                   # move t0 into t9
    bgt $t4, $t3, exit_for          # t4 <= height == FALSE
    
  while:
     
      bgt $t5, $t2, exit_while      # t5 <= t2 == FALSE
      sw $a2, ($t9)                 # store color into t9
      addi $t9, $t9, 4              # increment t9
      addi $t5, $t5, 1              # increment t5
      j while
      
  exit_while:
          addi $t0, $t0, 512        # add 512 to get to next line
          addi $t4, $t4, 1          # increment t4
          addi $t5, $zero, 0        # reset t5 to 0
          j for                     # again
exit_for:
  jr $ra
#***********************************************
# draw_diamond:
#  Draw diamond of given height peaking at given point.
#  Note: Assume given height is odd.
#-----------------------------------------------------
# draw_diamond(height, base_point_x, base_point_y)
# 	for (dy = 0; dy <= h; dy++)
# 		y = base_point_y + dy
#
# 		if dy <= h/2
# 			x_min = base_point_x - dy
# 			x_max = base_point_x + dy
# 		else
# 			x_min = base_point_x - floor(h/2) + (dy - ceil(h/2)) = base_point_x - h + dy
# 			x_max = base_point_x + floor(h/2) - (dy - ceil(h/2)) = base_point_x + h - dy
#
#   	for (x=x_min; x<=x_max; x++) 
# 			draw_diamond_pixels(x, y)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of top point of diamond in format (0x00XX00YY)
#    $a1 = height of the diamond (must be odd integer)
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_diamond: nop                 #### This does not work. Somewhere, my loop gets off.
        push($s0)
        push($s1)
        addi $t5, $zero, 0
        getCoordinates($a0 $t0 $t1)
        move $t2, $t0
        move $t3, $t1
        addi $s0, $zero, 0
        srl $t4, $a1, 1

for_diamond:
    bgt $s0, $a1, finished
    add $t3, $t3, $s0            # y = t3

while_diamond:    
    bgt $s0, $t4, do_upper
       subu $t5, $t2, $s0       # x_min = t5
       addu $t6, $t2, $s0       # x_max = t6
       j print_lower 

do_upper:
    subu $t5, $t2, $a1
    addu $t5, $t5, $s0         # upper x_min = t5
    addu $t6, $t2, $a1
    subu $t6, $t6, $s0         # upper x_max = t6
    j print_upper
    
    
    
print_upper:
     addu $t7, $zero, $t5  
    bitCoordinates($t7 $t3) 
   
print_UL:
        beq $t7, $t6, done_UL
        sw $a2, ($t7)
        subi $t7, $t7, 2
        subi $t5, $t5, 1
        j print_UL  

done_UL:
     addiu $t7, $t7, 516
     addi $s0, $s0, 1
     j for_diamond
     
print_lower:
     addu $t7, $zero, $t5
    bitCoordinates($t7 $t3) 
   
  
print_LL:
        beq $t5, $t6, done_LL
        nop
        sw $a2, ($t7)
        addiu $t7, $t7, 2
        addiu $t5, $t5, 1
        j print_LL        
           
done_LL:
     addiu $t7, $t7, 508
     addi $s0, $s0, 1
     
     j for_diamond
     
finished:
        pop($s1)
        pop($s0)
	jr $ra
	
