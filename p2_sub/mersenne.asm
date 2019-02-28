# Michael LeMay (mjlemay)
# This is my p2 MIPS work

main:

    .text

    .globl main

is_small_prime: #takes in integer p. Checks if p is prime

          .text
          li $t0, 2 #set i = 2
          addi $t1, $a0, -1 #save the value of p-1
    loop: div $a0, $t0 #p % i
          mfhi $t3 #get the mod value
          beq $t3, $0 not_done #compares t3 to the zero register,
                              #jumps past exit if not done
          move $v0, $0 #zeroes the return value
          jr $ra #return from this subroutine
not_done: addi $t0, $t0 1
          bne $t0, $t1 loop #If not equal, have not reached end of for loop yet.
          addi $v0, $0 1 #loads r.v. of 1 into register
          jr $ra #exit the function


print_big: #takes in and prints out a big integer in little endian format

      .text
      lw $t0 ($sp) #load b.n from the stack. c = b.n
      addiu $sp, $sp, 4 #shift stack pointer back up 4 bytes
      lw $t1, ($sp) #Load address b.digits[0] from stack
      addiu $sp, $sp, 4 #shift stack pointer back up 4 bytes
loop: addi $t0, $t0, -1 #get c by subtracting one from b.n. c -= 1 or c = b.n-1
      sll $t2, $t0, 2 #Calculate offset by shifting left twice, or multiplying by 4.
      lw $t3, $t2($t1) # $a0 = b.digits[c]. a0 is the register for printing
      lw $a0, ($t3)  # Load integer at address b.digits[0 + c] to printing register
      li $v0, 1 #load print int number code for sys call
      syscall #call the print statement
      slt $t3, $t0, $0 #puts 1 in t3 if t0 (c) is less than zero
      beq $t3, $0, loop #if c is greater than/equal to 0,
                        #jump up for another loop
      jr $ra #exit the function

compress: #takes in pointer to address a.

        .text
        lw $t0, ($a0) #$t0 = b.n. this will be a
        lw $t1, 4($a0) #$t1 = b.digits[0]
        addi $t2, $t0, -1 #i = a->n - 1
  loop: #get value at a->digits[i]
        # compare to zero
        # compare i ($t2) to zero
        # and them together
        addi $t0, $t0, -1 # if both, reduce $t1 by 1
        jr $ra  #exit the function

shift_right:



shift_left:



compare_big:



mult_big:



pow_big:



sub_big:



mod_big:



LLT:



mersenne_scan:
