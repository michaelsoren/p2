# Michael LeMay (mjlemay)
# This is my p2 MIPS work

  .globl main

#data are just the test print strings that I'm using
  .data
start:         .asciiz   "\nStarting Tests\n"
sp_test:       .asciiz   "\nSmall Prime Tests\n"
cmpress_test:  .asciiz   "\nCompress Test\n"
sr_test:       .asciiz   "\nShift Right Tests\n"
sl_test:       .asciiz   "\nShift Left Test\n"
cmp_test:      .asciiz   "\nComparison Tests\n"
add_test:       .asciiz  "\nAdd Tests (added)\n"
mult_test:     .asciiz   "\nMultiply Tests\n"
pow_test:       .asciiz  "\nPower Tests\n"
sub_test:       .asciiz  "\nSubtraction Tests\n"
mod_test:       .asciiz  "\nModulus Tests\n"
LLT_test:        .asciiz "\nLLT Tests\n"
mer_scan:        .asciiz "\nMersenne scan\n"

  .text
main:
    #print starting statement
    li $v0, 4
    la $a0, start
    syscall

    #save ra and callee saved registers
    addi $sp, $sp, -16
    sw $ra, ($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $a0, $v0
    li $v0, 4
    la $a0, sp_test
    syscall
    jal test_is_small_prime

    li $v0, 4
    la $a0, cmpress_test
    syscall
    jal test_compress

    li $v0, 4
    la $a0, sr_test
    syscall
    jal test_shift_right

    li $v0, 4
    la $a0, sl_test
    syscall
    jal test_shift_left

    li $v0, 4
    la $a0, cmp_test
    syscall
    jal test_compare_big

    li $v0, 4
    la $a0, mult_test
    syscall
    jal test_mult_big

    #Print out description, then run the test
    li $v0, 4
    la $a0, pow_test
    syscall
    jal test_pow_big

    #Print out description, then run the test
    li $v0, 4
    la $a0, sub_test
    syscall
    jal test_sub_big

    #Print out description, then run the test
    li $v0, 4
    la $a0, mod_test
    syscall
    jal test_mod_big

    #Print out description, then run the test
    li $v0, 4
    la $a0, LLT_test
    syscall
    jal test_LLT

    #Print out description, then run the test
    li $v0, 4
    la $a0, mer_scan
    syscall
    jal mersenne_scan

    #restore ra and callee saved registers
    lw $ra, ($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, -16 #shift stack pointer back

    li $v0, 10 #exit gracefully
    syscall

#Procedure: print_new_line
#Args: None
#Return: No value, just prints new line
#Description: Just prints new line out.
print_new_line:
    .data
new_line:      .asciiz   "\n"
                .text
                li $v0, 4
                la $a0, new_line
                syscall
                jr $ra

#############################################################
### Below are my mips implementations of testing helpers  ###
#############################################################

#All tests are in line with the tests asked for in the writeup

#Procedure: test_is_small_prime
#Args: None
#Return: No value
#Description: Setup and run the small prime test
test_is_small_prime:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    li $a0, 7
    jal is_small_prime
    move $a0, $v0 #move the output to the first parameter
    li $v0, 1 #load print int number code for sys call
    syscall #call the print statement
    jal print_new_line

    li $a0, 81
    jal is_small_prime
    move $a0, $v0 #move the output to the first parameter
    li $v0, 1 #load print int number code for sys call
    syscall #call the print statement
    jal print_new_line

    li $a0, 127
    jal is_small_prime
    move $a0, $v0 #move the output to the first parameter
    li $v0, 1 #load print int number code for sys call
    syscall #call the print statement
    jal print_new_line

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_compress
#Args: None
#Return: No value
#Description: Set up and run the compress test
test_compress:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    addi $sp, $sp, -1404
    li $t0, 4
    sw $t0, ($sp) #set n to 4
    li $t0, 3
    sw $t0, 4($sp) #create "0003" bigint
    sw $0, 8($sp)
    sw $0, 12($sp)
    sw $0, 16($sp)
    move $a0, $sp #move to first parameter slot
    jal compress
    move $a0, $sp
    jal print_big
    jal print_new_line
    addi $sp, $sp, 1404 #remove stack allocated big int

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_shift_right
#Args: None
#Return: None
#Description: Setup and run the shift_right test
test_shift_right:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    li $a0, 3 #sets up parameters
    li $a1, 0
    li $a2, 1
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    jal digit_to_big
    move $s0, $v0 #save output bigint
    move $a0, $s0 #make parameter
    jal shift_right #shift right three times
    jal shift_right
    jal shift_right
    move $a0, $s0
    jal print_big
    jal print_new_line
    addi $sp, $sp, 1404 #dereference bigint

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_shift_left
#Args: None
#Return: No value
#Description: Setup and run the shift_left test
test_shift_left:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    li $a0, 0 #sets up parameters
    li $a1, 7
    li $a2, 2
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    jal digit_to_big
    move $s0, $v0 #save output bigint
    move $a0, $s0 #make parameter
    jal shift_right #make 7000
    jal shift_right
    jal shift_left #shift left 2 times
    jal shift_left
    move $a0, $s0
    jal print_big
    jal print_new_line
    addi $sp, $sp, 1404 #shift the temp big off the stack

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_compare_big
#Args: None
#Return: No value
#Description: Set up and run the compare test
test_compare_big:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2
    li $a1, 4
    li $a2, 2
    jal digit_to_big
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    move $s0, $v0 #save 42 in s0
    li $a0, 0
    li $a1, 3
    li $a2, 2
    jal digit_to_big
    move $s1, $v0 #save 30 in s1

    move $a0, $s0 #set first comparison parameter
    move $a1, $s1 #set second comparison parameter
    jal compare_big #compare 42 to 30
    move $a0, $v0
    li $v0, 1
    syscall
    jal print_new_line

    move $a0, $s1 #set up parameters
    move $a1, $s0
    jal compare_big #compare 30 to 42
    move $a0, $v0
    li $v0, 1
    syscall
    jal print_new_line

    move $a0, $s0 #set up parameters
    move $a1, $s0
    jal compare_big #compare 42 to 42
    move $a0, $v0
    li $v0, 1
    syscall
    jal print_new_line
    addi $sp, $sp, 2808 #deallocate the last two big ints

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_mult_big
#Args: None
#Return: No value
#Description: Set up and test mult
test_mult_big:
    .text
    addi $sp, $sp, -16 #shift stack pointer down
    sw $ra, ($sp) #save ra
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 7 #put 7 in register
    li $a1, 0 #put 0 in ten register
    li $a2, 1 #put 1 digit
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 3 #put 3 in register
    li $a1, 0 #put 0 in ten register
    li $a2, 1 #put 1 digit
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 0 #put 0 in ten register
    li $a2, 1 #put 1 digit
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal mult_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #dereference 3 big ints

    #setup 42 and 30
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2 #put 2 in register
    li $a1, 4 #put 4 in ten register
    li $a2, 2 #put 2 digit
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 3 #put 3 in ten register
    li $a2, 2 #put 2 digit
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 0 #put 0 in ten register
    li $a2, 1 #put 1 digit
    jal digit_to_big
    move $s2, $v0 #temporary register
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal mult_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #dereference 3 big ints

    #setup 10 million and 9 million
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 1 #put 1 in ten register
    li $a2, 2 #put 2 digit
    jal digit_to_big
    move $s0, $v0
    move $a0, $s0
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 9 #put 9 in ten register
    li $a2, 2 #put 2 digit
    jal digit_to_big
    move $s1, $v0
    move $a0, $s1
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #put 0 in register
    li $a1, 0 #put 0 in ten register
    li $a2, 1 #put 1 digit
    jal digit_to_big
    move $s2, $v0 #temporary register
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal mult_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212

    lw $ra, ($sp) #restore ra
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_pow_big
#Args: None
#Return: No value
#Description: Sets up and runs the pow test
test_pow_big:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    #power test
    #create bigint 3
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 3
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s1, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1 #used as empty value
    li $a2, 4
    jal pow_big
    move $a0, $s1
    jal print_big
    jal print_new_line
    addi $sp, $sp, 2808 #reset stack pointer

    #create bigint 42
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2
    li $a1, 4
    li $a2, 2
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s1, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1 #used as empty value
    li $a2, 42
    jal pow_big
    move $a0, $s1
    jal print_big
    jal print_new_line
    addi $sp, $sp, 2808

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_sub_big
#Args: None
#Return: No value.
#Description: Sets up and runs the sub test
test_sub_big:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    #create bigints 7, 3, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 7
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 3
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1 #used as empty value
    move $a2, $s2
    jal sub_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    #create bigints 42, 12, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2
    li $a1, 4
    li $a2, 2
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2
    li $a1, 1
    li $a2, 2
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal sub_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    #create bigints 9 billion, 7654321, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 9
    li $a2, 2
    jal digit_to_big
    move $s0, $v0
    move $a0, $s0
    jal shift_right #create 9 billion
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right #9 with 9 zeroes
    addi $sp, $sp, -1404 #create 7654321
    li $t0, 7
    sw $t0, ($sp) #set n to 7
    li $t0, 1
    sw $t0, 4($sp)
    li $t0, 2
    sw $t0, 8($sp)
    li $t0, 3
    sw $t0, 12($sp)
    li $t0, 4
    sw $t0, 16($sp)
    li $t0, 5
    sw $t0, 20($sp)
    li $t0, 6
    sw $t0, 24($sp)
    li $t0, 7
    sw $t0, 28($sp)
    move $s1, $sp #save 7654321
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal sub_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_mod_big
#Args: None
#Return: No value
#Description: Sets up and runs the mod test
test_mod_big:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    #create bigints 7, 3, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 7
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 3
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1 #used as empty value
    move $a2, $s2
    jal mod_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    #create bigints 42, 12, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 8
    li $a1, 4
    li $a2, 2
    jal digit_to_big
    move $s0, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 2
    li $a1, 1
    li $a2, 2
    jal digit_to_big
    move $s1, $v0
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal mod_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    #create bigints 9 billion, 7654321, and an empty one
    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0
    li $a1, 9
    li $a2, 2
    jal digit_to_big
    move $s0, $v0
    move $a0, $s0
    jal shift_right #shift 90 all the way right to 9 billion
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right
    jal shift_right #9 with 9 zeroes
    addi $sp, $sp, -1404 #create space for 7654321
    li $t0, 7
    sw $t0, ($sp) #set n to 7
    li $t0, 1
    sw $t0, 4($sp)
    li $t0, 2
    sw $t0, 8($sp)
    li $t0, 3
    sw $t0, 12($sp)
    li $t0, 4
    sw $t0, 16($sp)
    li $t0, 5
    sw $t0, 20($sp)
    li $t0, 6
    sw $t0, 24($sp)
    li $t0, 7
    sw $t0, 28($sp)
    move $s1, $sp #save 7654321
    addi $sp, $sp, -1404 #allocate size of bigint on stack.
    li $a0, 0
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s2, $v0
    #test and print
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal mod_big
    move $a0, $s2
    jal print_big
    jal print_new_line
    addi $sp, $sp, 4212 #free allocated stack space

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#Procedure: test_LLT
#Args: None
#Return: No value
#Description: Sets up and runs the LLT test
test_LLT:
    .text
    addi $sp, $sp, -4 #shift stack pointer down
    sw $ra, ($sp) #save ra

    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #create empty bigint
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s0, $v0
    li $a1, 11 #set p
    move $a0, $s0
    jal LLT
    move $a0, $v0 #save the output
    li $v0, 1
    syscall
    jal print_new_line
    addi $sp, $sp, 1404 #remove stack allocated for big int

    addi $sp, $sp, -1404 #allocate size of bigint on stack
    li $a0, 0 #create empty bigint
    li $a1, 0
    li $a2, 1
    jal digit_to_big
    move $s0, $v0
    li $a1, 61 #change p
    move $a0, $s0
    jal LLT
    move $a0, $v0 #save the output
    li $v0, 1
    syscall
    jal print_new_line
    addi $sp, $sp, 1404 #remove stack allocated for big int

    lw $ra, ($sp) #restore ra
    addi $sp, $sp, 4 #shift stack pointer back up
    jr $ra #exit


#############################################################
### Below are my mips implementations of needed functions ###
#############################################################

#Procedure: is_small_prime
#Args: Takes in an allocated bigint to check for primeness
#Return: 0 if not prime, 1 if prime
#Description: Basic for loop to check for primeness
is_small_prime: #takes in integer p. Checks if p is prime
            .text
            li $t0, 2 #set i = 2
            addi $t1, $a0, -1 #save the value of p-1
            slt $t2, $t0, $t1 #set t2 to 1 if i is less than p - 1
            bne $t2, $0, .loop0 #if meets the condition, start the loop
            #otherwise, we have a value of 3 or less. Return 1
            addi $v0, $0, 1 #loads r.v. of 1 into register
            jr $ra #leave
    .loop0: div $a0, $t0 #p % i
            mfhi $t3 #get the mod value
            bne $t3, $0, .not_done0 #compares t3 to the zero register,
                                #jumps past exit if not done
            move $v0, $0 #zeroes the return value
            jr $ra #return from this subroutine
.not_done0: addi $t0, $t0, 1
            bne $t0, $t1, .loop0 #If not equal, have not reached end of for loop yet.
            addi $v0, $0, 1 #loads r.v. of 1 into register
            jr $ra #exit the function


#Procedure: digit_to_big
#Args: The first digit (little endian) is first, second digit (little endian)
#      is second, and the length of the bigint (either 1 or 2) is third.
#Return: address of b (it's just the current value of $sp)
#Description: Before this is called, the stack pointer should be shifted
#             down to fit the new big int. This procedure loads in the
#             required info into the bigint. It does 2 digits, rather than
#             one, since that really helps make the tests easier to run.
digit_to_big:
        .text
        sw $a2, ($sp) #b.n = parameter n
        sw $a0, 4($sp) #b.digits[0] = a (ones digit)
        sw $a1, 8($sp) #b.digits[1] = a (twos digit)
        move $v0, $sp #return allocated address for b
        jr $ra


#Procedure: print_big
#Args: address of bigint to print
#Return: No value
#Description: Takes a given big int, then iterates over it starting at the
#             end. Prints out each digit, from highest to lowest
print_big:
        .text
        lw $t0 ($a0) #load b.n from memory. c = b->n
        addi $t1, $a0, 4 #Load address of b.digits[0]
.loop1: addi $t0, $t0, -1 #get c by subtracting one from b.n. c -= 1 or c = b.n-1
        sll $t2, $t0, 2 #Calculate offset by shifting left twice, or multiplying by 4.
        add $t3, $t2, $t1 #calculate the address of b.digits[0 + c]
        lw $a0, ($t3)  # Load integer at address b.digits[0 + c] to printing register
        li $v0, 1 #load print int number code for sys call
        syscall #call the print statement
        bne $t0, $0, .loop1 #if c is equal to zero, I know I'm done
        jr $ra #exit the function


#Procedure: compress
#Args: Address to be compressed
#Return: No value
#Description: Compresses down the given bigint at the address
#             by adjusting the bigint size, n. The procedure
#             essentially removes leading zeros by counting them.
compress: #takes in pointer to address a.
            .text
            lw $t0, ($a0) #$t0 = a.n. a is an address from memory
            addi $t1, $a0, 4 #$t1 = a.digits[0]
            addi $t2, $t0, -1 #i = a->n - 1
    .loop2: sll $t3, $t2, 2 #calculate byte offset for c.
            add $t4, $t3, $t1 #calculate memory address
            lw $t5, ($t4) #get value at a->digits[0 + i]
            bne $t5, $0, .exit2 # a->digits[i] == 0
            beq $t2, $0, .exit2 # i != 0
            addi $t0, $t0, -1 # if both, reduce $t1 by 1
            addi $t2, $t2, -1 #i--
            bne $t2, $0, .loop2 #restart loop if i is greater than 0
    .exit2: sw $t0, ($a0) #loads the new value of a->n into memory
            jr $ra  #exit the function
      #note that I don't have to modify digits, changing n suffices


#Procedure: shift_right
#Args: address that should be shifted left
#Return: No value
#Description: Adds a 0 onto the end of the bigint and shifts
#             the other values over to the right.
shift_right:
              .text
              lw $t0 ($a0) #i = a->n. grab a->n and store in $t0
              addi $t2, $t0, 1 #store a->n += 1, while we have this value in register.
              sw $t2, ($a0) #writes new a->n value to memory
      .loop3: sll $t2, $t0, 2 #convert i to byte offset, load into register t3
              addi $t0, $t0, -1 #i = i - 1.
              sll $t3, $t0, 2 #convert i - 1 to byte offset, load into register t4
              add $t4, $a0, $t3 #calculate address of a->digits[i - 1]
              lw $t3, 4($t4) #a->digits[i - 1] (no longer need i - 1, so use it's register)
              add $t4, $a0, $t2 #calculate address of a->digits[i]
              sw $t3, 4($t4) #a->digits[i] = a->digits[i-1]
              bne $t0, $0, .loop3 #jump back up if i is not zero
              sw $0, 4($a0) #set a->digits[$t1] to be 0.
              jr $ra #exit


#Procedure: shift_left
#Args: address of bigint to shift left
#Return: No value
#Description: Shifts every value of bigint to left, effectively dividing by 10
shift_left:
          .text
          lw $t0 ($a0) #grab a->n and store in $t0
          move $t2, $0 #i = 0
  .loop4: sll $t3, $t2, 2 #shifts i into byte offset
          addi $t2, $t2, 1 #i += 1
          sll $t4, $t2, 2 #shifts i + 1 into byte offset
          add $t4, $t4, $a0 #calculate address of a->digits[i + 1], store in t4
          lw $t4, ($t4) #save value of a->digits[i + 1] in t3
          add $t3, $t3, $a0 #calculate address of a->digits[i], store in t3
          sw $t4, ($t3) #a->digits[i] = a->digits[i + 1]
          bne $t0, $t2, .loop4 # if i != a->n, jump back up to loop
          addi $t0, $t0, -1 #Calculate a->n - 1
          sw $t0, ($a0) #store it
          #shift_left complete, now just need to call compress
          addi $sp, $sp, -4 #shift stack pointer down to save $ra
          sw $ra, ($sp) #save ra
          jal compress #call compress on (a). $a0 still has reference to Bigint a
          lw $ra, 0($sp) #reload ra
          addi $sp, $sp, 4 #move stack pointer back up
          jr $ra


#Procedure: compare_big
#Args: two bigint addresses, one stored in a and the other in b
#Return: -1 if a is less than b, 0 if equal, and 1 if a is greater than b
#Description: Sets up and runs the mod test
compare_big: #pointer to a in a0, pointer to b in a1
            .text
            lw $t0, ($a0) #a.n
            lw $t1, ($a1) #b.n
            beq $t0, $t1, .equal #if the two are equal, jump to the loop code
            slt $t2, $t0, $t1 #if a.n is less than b.n, put 1 into t2, otherwise 0
            bne $t2, $0, .n_one #Is a.n less than b.n, jump to less
    .one:  li $v0, 1 #a.n is greater than b.n, return 1
            j .exit #jump to end
   .n_one:  li $v0, -1 #a.n is less than b.n, return -1
            j .exit #jump to end
    .equal: addi $t0, $t0, -1 #i = a.n - 1
    .loop5: sll $t5, $t0, 2
            add $t3, $t5, $a0 #address of a.digits[0 + i] - 4
            add $t4, $t5, $a1 #address of b.digits[0 + i] - 4
            lw $t3, 4($t3) #value of a.digits[0 + i]
            lw $t4, 4($t4) #value of b.digits[0 + i]
            bne $t3, $t4, .notequal #if a.digits[i] != b.digits[i], compare the two
            addi $t0, $t0, -1 #i--
            slt $t1, $t0, $0 #put 1 in t1 if i is less than 0
            beq $t1, $0, .loop5 #if i >= 0, jump back up to start of loop
            move $v0, $0 #set return value to zero
            jr $ra #exit
.notequal:  slt $t5, $t3, $t4 #if a < b, put 1 in t5.
            bne $t5, $0, .n_one #a less than b, return -1
            j .one #a is greater than b, return 1
    .exit:  jr $ra #exit


#Procedure: mult_big
#Args: Takes in two bigints (a,b), and a bigint to store the result (c)
#Return: None (set passed in bigint with result)
#Description: Follows the algorithm from mersenne.c. Calculate c = a * b
#             I use temporary bigints to avoid having overwriting the same
#             addresses. This is necessary for when I have something like
#             c = a * a, where a is both addresses, or s = s * s, where s
#             is the same address in all three cases.
mult_big:
            .text
            addi $sp, $sp, -8 #shift stack pointer down to save $ra
            sw $ra, ($sp) #save ra
            sw $s0, 4($sp)
            lw $t0, ($a0) #a->n
            lw $t1, ($a1) #b->n
            add $t2, $t0, $t1 # c->n
            addi $sp, $sp, -1404 #allocate temporary c
            sw $t2, ($sp) #save c->n value to memory.
            #clear out temp c
            move $t3, $0 #i = 0
  .clear_c: sll $t4, $t3, 2 #convert i to byte offset of i
            add $t4, $t4, $sp #calculate address c->digits[i] - 4
            sw $0, 4($t4) #zeroes out c->digits[i] in memory
            addi $t3, $t3, 1 #increment i
            bne $t3, $t2, .clear_c #If i < c->n, restart loop
            #start multiplication loop
            move $t3, $0 #i = 0
  .i_loop:  move $t4, $0 #carry = 0
            move $t5, $t3 #j = i
            add $a3, $t0, $t3 #calculate a.n + i and store in a3
  .j_loop:  sub $t6, $t5, $t3 #j - i
            sll $t6, $t6, 2 #calculate byte offset of j - i
            add $t6, $t6, $a0 #calculate address of a.digits[j - i]
            lw $t6, 4($t6) #get value of a.digits[j - i]
            sll $t7, $t3, 2 #byte offset of i
            add $t7, $t7, $a1 #address of b.digits[i] - 4
            lw $t7, 4($t7) #value at b.digits[i]
            mult $t6, $t7 #b.digits[i] * a.digits[j - i]
            mflo $t6 #get result
            add $t6, $t4, $t6 #carry + (b.digits[i] * a.digits[j - i])
            sll $t7, $t5, 2 #set t7 to byte offset of j
            add $t7, $sp, $t7 #calculate address of c.digits[j] - 4
            lw $t2, 4($t7) #get value at c.digits[j]
            add $t6, $t2, $t6 #c.digits + (b.digits[i] * a.digits[j - i]) + carry
            li $t2, 10 #put ten in s0
            div $t6, $t2 #val / 10 and val % 10
            mflo $t4 #carry = val / 10
            mfhi $t2 #val % 10
            sw $t2, 4($t7) #c.digits = val % 10
            addi $t5, $t5, 1 #j++
            bne $t5, $a3, .j_loop
            #end of j loop
            beq $0, $t4, .finish_up #if carry = 0, we're done with this loop of i
            sll $t7, $t5, 2 #set t7 to be byte offset of this new j
            add $t7, $sp, $t7
            lw $t2, 4($t7) #get the value of c.digits[j]
            add $t5, $t2, $t4 #val = c.digits[j] + carry
            li $t6, 10 #sets t6 to ten
            div $t5, $t6 #val / and % 10
            mfhi $t6 #val % 10
            mflo $t4 #carry = val / 10
            sw $t6, 4($t7) #c.digits[j] = val % 10
.finish_up: addi $t3, $t3, 1 #i++
            bne $t3, $t1, .i_loop #If i < b.n, restart loop
            #done with loops just compress, copy over, and finish
            move $s0, $a0 #save bigint a in t0
            move $a0, $sp #move bigint c into a
            jal compress #call compress on c
            #copy my created c into c
            move $t0, $0 #i = 0
            lw $t1, ($sp) #get temporary return .n
            sw $t1, ($a2) #set return parameter .n
.cpy_loop1: sll $t2, $t0, 2 #byte offset of i
            add $t3, $sp, $t2 #address of temporary c - 4
            add $t4, $a2, $t2 #address of return c - 4
            lw $t3, 4($t3) #get value of temp_c.digits[i]
            sw $t3, 4($t4) #set value of c.digits[i]
            addi $t0, $t0, 1 #i++
            bne $t1, $t0, .cpy_loop1
            addi $sp, $sp, 1404
            move $a0, $a3 #reset a
            lw $ra, ($sp) #reload ra
            lw $s0, 4($sp) #reload $s0
            addi $sp, $sp, 8 #move stack pointer back up
            jr $ra


#Procedure: pow_big
#Args: Takes in address of given bigint (1), address of result int (2), and
#      p value that serves as the power (3)
#Return: None (set passed in bigint with result)
#Description: Follows the algorithm from mersenne.c, using functions previously
#             defined. Main difference is putting the return value in given c
#             to make it easier. (c = a^p)
#             Note: I use temporary holders to avoid
#             issues where I pass in the same address multiple times
#             to do the power operation.
#             Note: I also use an alternating method with b and c. I switch out
#             my storage address, c, with the value parameter, b, every time
#             to store the temporary result before another multiplication.
pow_big:
                .text
                addi $sp, $sp, -28 #shift stack pointer down to save $ra and $s0
                sw $s5, 24($sp)
                sw $s4, 20($sp)
                sw $s3, 16($sp)
                sw $s2, 12($sp)
                sw $s1, 8($sp)
                sw $s0, 4($sp) #save callee saved registers on stack
                sw $ra, ($sp) #save ra for future function call
                move $s0, $a2 #put p into s0
                move $s5, $a0 #save the a0 reference
                move $t0, $0 #i = 0
                lw $t4, ($a0) #grab a.n
                addi $sp, $sp, -1404 #allocate space for b
                sw $t4, ($sp) #set b.n = a.n
   .set_b_loop: sll $t5, $t0, 2 #byte offset of this current i
                add $t7, $t5, $a0 #calculate address for a.digits[i] - 4
                lw $t6, 4($t7) #get a.digits[i]
                add $t7, $t5, $sp #calculate address for b.digits[i] - 4
                sw $t6, 4($t7) #b.digits[i] = a.digits[i]
                addi $t0, $t0, 1 #i++
                bne $t0, $t4, .set_b_loop
                move $s1, $sp #save b in $s1
                #created Bigint b that is equal to a.
                addi $sp, $sp, -1404 #allocate space for temporary result holder c
                move $s2, $sp #save reference to c
                move $s3, $a1 #save reference to final result holder
                #created Bigint c that will store the result of mult_big
                li $s4, 1 #i = 1
                move $a1, $s1 #set b as second parameter
                move $a2, $s2 #set c as third parameter
        .loop7: jal mult_big #call mult big with (a, b, c)
                addi $s4, $s4, 1 #i++
                move $a0, $s5 #set a as the first parameter
                move $t1, $a1 #save pointer to second param
                move $a1, $a2 #swap b and c part one
                move $a2, $t1 #swap b and c part two
                bne $s4, $s0, .loop7 #if i != p, jump back up to loop

                li $t0, 2 #load a 2 into a register
                div $s4, $t0 #divide i by two
                mfhi $t0 #get result
                beq $t0, $0, .even #jump if i is even
                move $s4, $s1 #i is odd, use b
                j .cont
         .even: move $s4, $s2 #i is even, use c
         .cont: move $t0, $0 #i = 0
                lw $t4, ($s4) #grab res.n
                sw $t4, ($s3) #set c.n = res.n
   .set_c_loop: sll $t5, $t0, 2 #byte offset of this current i
                add $t7, $t5, $s4 #calculate address for res.digits[i] - 4
                lw $t6, 4($t7) #get res.digits[i]
                add $t7, $t5, $s3 #calculate address for c.digits[i] - 4
                sw $t6, 4($t7) #c.digits[i] = res.digits[i]
                addi $t0, $t0, 1 #i++
                bne $t0, $t4, .set_c_loop
                move $a1, $s3
                move $a2, $s0
                addi $sp, $sp, 2808 #remove both local bigints from stack
                #cleanup
                lw $s5, 24($sp)
                lw $s4, 20($sp)
                lw $s3, 16($sp) #restore stack saved registers
                lw $s2, 12($sp)
                lw $s1, 8($sp)
                lw $s0, 4($sp)
                lw $ra, ($sp)
                addi $sp, $sp, 28 #shift stack pointer back up
                jr $ra


#Procedure: sub_big
#Args: Takes in two big ints (a,b) to subtract and then one (c) to store.
#Return: None (set passed in bigint with result)
#Description: Follows the algorithm from mersenne.c, using functions previously
#             defined. Main difference is putting the return value in given c
#             to make it easier. c = a - b. Uses temporary bigint to avoid
#             issues with reading and writing to the same reference.
sub_big:
            .text
            lw $t0, ($a0) #saves a.n in t0
            lw $t1, ($a1) #saves b.n to t0
            sw $t0, ($a2) #c.n = a.n
            #adjust stack to save s0
            addi $sp, $sp, -8 #move stack pointer down
            sw $s0, 4($sp) #save s0
            sw $ra, ($sp) #save return address
            #set up for subtract loop
            move $t2, $0 #i = 0
            move $t3, $0 #carried_last_time = 0
            move $t4, $0 #carry_this_time = 0
            #setup values and addresses of this iteration
    .loop8: sll $t6, $t2, 2 #byte offset of i
            add $t7, $t6, $a0 #address of a.digits[i] - 4
            add $s0, $t6, $a1 #address of b.digits[i] - 4
            add $t6, $t6, $a2 #address of c.digits[i] - 4
            lw $t7, 4($t7) #a_val = a.digits[i]
            lw $s0, 4($s0) #b_val = b.digits[i]
            #do carry checking
            slt $t5, $t2, $t1 #check if i < b.n and jump on if so
            bne $0, $t5, .set_carry
            move $s0, $0 #b_val = 0
.set_carry: sub $t5, $t7, $t3 #a_val - 1
            slt $t4, $t5, $s0 #if a_val - carried_last_time < b_val, make carry_this_time 1, else 0
     .calc: li $t5, 0 #res = 0
            beq $t4, $0, .last_time #carry_this_time == 0
            li $t5, 10 #res = 10
.last_time: sub $t5, $t5, $t3 #res = res - carried_last_time
            add $t5, $t5, $t7 #res = res + a_val
            sub $t5, $t5, $s0 #res = res - b_val (b_val could have been zeroed earlier)
            sw $t5, 4($t6) #c.digits[i] = res
            addi $t2, $t2, 1 #i++
            move $t3, $t4 #carried_last_time = carry_this_time
            bne $t2, $t0, .loop8 #jump back up if not at c.n

            move $s0, $a0 #save a0
            move $a0, $a2 #move return value to be compressed
            jal compress #call compress
            move $a2, $a0 #move a2 back to its spot
            move $a0, $s0 #reset a0 as well

            #adjust stack back up
            lw $s0, 4($sp) #reset the stack pointer
            lw $ra, ($sp) #reset $ra
            addi $sp, $sp, 8 #reset stack pointer
            jr $ra


#Procedure: mod_big
#Args: Takes in 3 bigints. a and b (params 1 and 2) are what we will
#      be doing a % b with. c, the third parameter, is for storing
#      the result. (c = a % b)
#Return: nothing, return is put into c
#Description: Follows the algorithm from mersenne.c. Only twist is
#             that I copy the return value back into the given c, rather than
#             return the value. I found it easier to do this way. I also use
#             temporary bigints to fix the aliasing problem
mod_big:
            .text
            addi $sp, $sp, -16 #shift stack pointer down and save registers
            sw $s2, 12($sp)
            sw $s1, 8($sp)
            sw $s0, 4($sp)
            sw $ra, ($sp)
            lw $t0, ($a1) #grab b.n
            move $s0, $a0 #put param 1 in a register
            move $s1, $a1 #put param 2 in a register
            move $s2, $a2 #put param 3 in a register

            #create b, I will use my input b as original b to avoid modifying it.
            addi $sp, $sp, -1404 #allocate new bigint on stack
            sw $t0, ($sp) #set new bigint to have length n
            li $t1, 0 #i = 0
.cpy_loop2: sll $t2, $t1, 2 #byte offset of i
            add $t4, $t2, $a1 #address of b.digits[i] - 4
            add $t3, $t2, $sp #address of original_b
            lw $t4, 4($t4) #load value of b.digits[i]
            sw $t4, 4($t3) #set original_b.digits[i] to b.digits[i]
            addi $t1, $t1, 1 #i++
            bne $t1, $t0, .cpy_loop2 #if i != b.n, jump back up
            #done creating b_original, shift right loop for b

      .srl: jal compare_big #call compare big. a and b are in place
            li $t0, 1 #dput a 1 on a register
            bne $t0, $v0, .leave_srl #leave if return value was not 1
            move $a0, $sp #put b in the first parameter slot
            jal shift_right #shift b to the right
            move $a0, $s0 #put a back in the first slot for the next compare_big
            move $a1, $sp #put b back in the second slot just in case
            j .srl #jump back up to while loop start
.leave_srl: move $a0, $sp #put b in the first parameter slot
            jal shift_left #call shift left on b
            move $a0, $s0 #put a back
            move $a1, $sp #put b back

            #start double for loop
   .w_loop: move $a0, $sp #shift b to first param
            move $a1, $s1 #shift original_b to second param
            jal compare_big #compare b and original b
            li $t0, -1 #prep for equals
            beq $v0, $t0, .leave_out #check if return equals -1, and leave outer loop if so
  .inner_w: move $a1, $sp #set second param to b
            move $a0, $s0 #set first param to a
            jal compare_big #compare the two
            li $t0, -1 #load register for use on next line
            beq $v0, $t0, .leave_in #leave inner loop if compare ret was -1
            move $a0, $s0 #set a as the first param
            move $a1, $sp #set b as second param
            move $a2, $s0 #put a in the third slot
            jal sub_big #a = a - b
            j .inner_w #restart inner while loop
 .leave_in: move $a0, $sp #move b to first param
            jal shift_left #call shift_left
            j .w_loop #jump back up to while loop start
.leave_out: #copy over result
            move $t0, $0 #set i to 0
            lw $t5, ($s0) #get a.n
            sw $t5, ($s2) #set c.n
 .exit_cpy: sll $t1, $t0, 2 #byte offset of i
            add $t2, $t1, $s0 #address of a.digits - 4
            add $t3, $t1, $s2 #address of c.digits - 4
            lw $t4, 4($t2) #load a.digits[i]
            sw $t4, 4($t3) #store in c.digits[i]
            addi $t0, $t0, 1 #i++
            bne $t0, $t5, .exit_cpy #restart copy
            addi $sp, $sp, 1404 #remove original_b from stack
            move $a0, $s0 #reset first parameter
            move $a1, $s1 #reset second parameter
            move $a2, $s2 #reset third parameter
            #cleanup
            lw $s2, 12($sp) #reset callee saved registers
            lw $s1, 8($sp)
            lw $s0, 4($sp)
            lw $ra, ($sp)
            addi $sp, $sp, 16 #shift stack pointer back up
            jr $ra


#Procedure: LLT
#Args: Takes in an allocated bigint (c), for holding return value, and a p value
#      which will be the p in 2^p - 1
#Return: 1 if prime, 0 if not prime.
#Description: Follows the algorithm from mersenne.c, using functions previously
#             defined.
LLT:
            .text
            #save callee saved registers
            addi $sp, $sp, -32 #shift stack pointer down
            sw $s7, 28($sp)
            sw $s6, 24($sp)
            sw $s4, 20($sp)
            sw $s3, 16($sp)
            sw $s2, 12($sp)
            sw $s1, 8($sp)
            sw $s0, 4($sp)
            sw $ra, ($sp) #save all the relevant/used registers

            #set up all the stack declared bigints needed

            addi $sp, $sp, -1404 #allocate size of bigint on stack. This is zero
            li $t0, 1 #put 1 in temporary register
            sw $t0, ($sp) #zero.n = 1
            sw $0, 4($sp) #zero.digits[0] = 0
            move $s0, $sp #save bigint
            addi $sp, $sp, -1404 #allocate size of bigint on stack. This is one
            li $t0, 1 #put 1 in temporary register
            sw $t0, ($sp) #one.n = 1
            sw $t0, 4($sp) #one.digits[0] = 1
            move $s1, $sp #save bigint
            addi $sp, $sp, -1404 #allocate size of bigint on stack. This is two
            sw $t0, ($sp) #two.n = 1
            li $t0, 2 #put 2 in a temprorary register
            sw $t0, 4($sp) #two.digits[0] = 2
            move $s2, $sp #save bigint
            addi $sp, $sp, -1404 #allocate size of bigint on stack. This is four
            li $t0, 1 #put 1 in temporary register
            sw $t0, ($sp) #four.n = 1
            li $t0, 4 #put 4 in a temprorary register
            sw $t0, 4($sp) #four.digits[0] = 4
            move $s3, $sp #save bigint

            #save the parameters before I start calling stuff
            move $s6, $a0 #save the pointer to c
            move $s7, $a1 #save p

            #initial calculations of MP

            move $a0, $s2 #make two the first parameter
            move $a1, $s6 #make c the second parameter
            move $a2, $s7 #make p the third parameter
            jal pow_big

            move $a0, $s6 #make c the first parameter
            move $a1, $s1 #make one the second parameter
            move $a2, $s6 #make c the third parameter
            jal sub_big

            #for loop
            li $s4, 0 #i = 0
            addi $s7, $s7, -2 #p - 2
    .loop9:
            move $a0, $s3 #set first parameter to s
            move $a1, $s3 #set second parameter to s
            move $a2, $s3 #set third parameter to s
            jal mult_big #multiply s = s * s
            move $a0, $s3 #set first parameter to s
            move $a1, $s2 #set second parameter to two
            move $a2, $s3 #set third parameter to s
            jal sub_big #s = s - two
            move $a0, $s3 #set first parameter to s
            move $a1, $s6 #set second parameter to Mp
            move $a2, $s3 #set third parameter to s
            jal mod_big #s = s % Mp
            addi $s4, $s4, 1 #i++
            bne $s4, $s7, .loop9 #restart loop if i != p - 2
            #compare the result to zero
            move $a0, $s3 #first parameter is whatever is in s
            move $a1, $s0 #second parameter is zero
            jal compare_big #call compare big
            beq $0, $v0, .prime #check if the return value was zero
            move $v0, $0 #set return value to zero otherwise
            j .cleanup #jump over prime return value
    .prime: li $v0, 1 #set prime return value
  .cleanup: addi $sp, $sp, 5616 #dereference stack allocated bigints (4 of thems)
            lw $ra, ($sp) #reset all the callee saved registers
            lw $s0, 4($sp)
            lw $s1, 8($sp)
            lw $s2, 12($sp)
            lw $s3, 16($sp)
            lw $s4, 20($sp)
            lw $s6, 24($sp)
            lw $s7, 28($sp)
            addi $sp, $sp, 32 #jump stack pointer back up
            jr $ra


#Procedure: mersenne_scan
#Args: None
#Return: No value, just printing stuff out
#Description: Run LLT from 2-550 and print out the relevant stuff. Same general
#             function as main.c from mersenne.c
mersenne_scan:
            .data
            testing_p:     .asciiz    "Testing p = "
            found_prime:   .asciiz    " found prime Mp = "
            n_found_prime: .asciiz    " Mp not prime"

                    .text
                    addi $sp, $sp, -24
                    sw $s7, 20($sp)
                    sw $s6, 16($sp)
                    sw $s5, 12($sp)
                    sw $s1, 8($sp)
                    sw $s0, 4($sp)
                    sw $ra, ($sp)
                    li $s0, 3 #p = 3
                    li $s1, 550 #save 550

                    #0th, create the two bigints I'll need on the stack. save in s registers
                    addi $sp, $sp, -1404 #allocate size of bigint on stack. This is a
                    li $t0, 1 #put 1 in temporary register
                    sw $t0, ($sp) #a.n = 1
                    sw $t0, 4($sp) #a.digits[0] = 1
                    move $s5, $sp #saves pointer to a
                    addi $sp, $sp, -1404 #allocate size of bigint on stack. This is b
                    sw $t0, ($sp) #b.n = 1
                    li $t0, 2 # Put 2 into temporary register
                    sw $t0, 4($sp) #b.digits[0] = 2
                    move $s6, $sp #saves pointer to b
                    addi $sp, $sp, -1404 #allocate size of bigint on stack. This is c
                    move $s7, $sp #saves pointer to c

                    #First check if p is prime
           .loop10: move $a0, $s0 #load p into a0
                    jal is_small_prime #call small prime
                    beq $v0, $0 .prep_for_restart
                    li $v0, 4 #set string print code
                    la $a0, testing_p #setup testing p string
                    syscall #print it
                    move $a0, $s0
                    li $v0, 1 #set int print code
                    syscall #print it out
                    #Then run LLT to get the primeness test on 2^p - 1
                    move $a0, $s7 #puts c as the first parameter
                    move $a1, $s0 #puts p as the second parameter
                    jal LLT #call llt
                    #then check return value
                    beq $v0, $0, .not_prime
                    li $v0, 4 #set string print code
                    la $a0, found_prime #load found prime string
                    syscall #print
                    move $a0, $s6 #move b into the first parameter slot
                    move $a1, $s7 #move c (output) into second parameter slot
                    move $a2, $s0 #move p into third parameter slot
                    jal pow_big
                    move $a0, $s7 #move c into first parameter slot
                    move $a1, $s5 #move a into second parameter slot
                    move $a2, $s7 #move c into third parameter slot as output
                    jal sub_big
                    move $a0, $s7
                    jal print_big
                    jal print_new_line #print new line here so I don't have issues
                    #with tons of empty lines printed for non-primes
                    j .prep_for_restart #jump over not_prime print
        .not_prime: li $v0, 4 #set string print code
                    la $a0, n_found_prime #load did not find prime string
                    syscall #print
                    jal print_new_line #print new line here so I don't have issues
                    #with tons of empty lines printed for non-primes
 .prep_for_restart: addi $s0, $s0, 1 #i++
                    bne $s0, $s1, .loop10 #jump back up

                    #reset stack
                    addi $sp, $sp, 4212 #dereference a,b,c
                    lw $ra, ($sp) #reset ra and all the old stack values
                    lw $s0, 4($sp)
                    lw $s1, 8($sp)
                    lw $s5, 12($sp)
                    lw $s6, 16($sp)
                    lw $s7, 20($sp)
                    addi $sp, $sp, 24 #reset stack pointer
                    jr $ra #exit the function
