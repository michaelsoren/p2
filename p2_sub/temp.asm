# Michael LeMay (mjlemay)
# This is my p2 MIPS work

main:
  .data
out_string:    .asciiz   "\nStarting some tests!\n"
new_line:      .asciiz   "\n"

  .text
    li $v0, 4
    la $a0, out_string
    syscall

    #li $a0, 7
    #jal is_small_prime
    #move $a0, $v0
    #li $v0, 1
    #syscall

    #li $a0, 81
    #jal is_small_prime
    #move $a0, $v0
    #li $v0, 1
    #syscall

    #li $a0, 127
    #jal is_small_prime
    #move $a0, $v0
    #li $v0, 1
    #syscall
    addi $a0, $0, 5
    jal digit_to_big
    move $s0, $v0
    addi $a0, $0, 9
    jal digit_to_big
    move $s1, $v0
    #li $a0, 1404 #max size of a Bigint
    #li $v0, 9 #code for allocate memory
    #syscall #allocate memory
    #move $s0, $v0 #save address of biginteger in t1
    #addi $t0, $0, 4 #put 4 into temporary address (b.n)
    #sw $t0, ($s0) #store this value in memory
    #addi $t0, $0, 7 #put 8 in temporary register
    #sw $t0, 4($s0) #set the other three slots
    #sw $0, 8($s0)
    #sw $t0, 12($s0)
    #sw $t0, 16($s0)
    move $a0, $s0 #sets up for function call
    jal print_big
    jal print_new_line
    move $a0, $s1
    jal print_big
    jal print_new_line
    #move $a0, $s0
    #jal compress
    #jal print_new_line
    #move $a0, $s0
    #jal print_big
    #jal print_new_line
    move $a0, $s0
    jal shift_right
    move $a0, $s1
    jal shift_right
    move $a0, $s1
    jal print_big
    jal print_new_line
    move $a0, $s0
    jal print_big
    jal print_new_line
    lw $a0, ($s1)
    li $v0, 1
    syscall

    li $v0, 10
    syscall

    print_new_line: li $v0, 4
                    la $a0, new_line
                    syscall
                    jr $ra

    digit_to_big:
                    addi $sp, $sp, -1404 #allocate size of bigint on stack
                    addi $t0, $0, 1 #put 1 in temporary register
                    sw $t0, ($sp) #b.n = 1
                    sw $a0, 4($sp) #b.digits[0] = a
                    move $v0, $sp
                    jr $ra

    is_small_prime: #takes in integer p. Checks if p is prime

                .text
                li $t0, 2 #set i = 2
                addi $t1, $a0, -1 #save the value of p-1
         .loop0: div $a0, $t0 #p % i
                mfhi $t3 #get the mod value
                bne $t3, $0, .not_done1 #compares t3 to the zero register,
                                    #jumps past exit if not done
                move $v0, $0 #zeroes the return value
                jr $ra #return from this subroutine
     .not_done0: addi $t0, $t0 1
                bne $t0, $t1 .loop1 #If not equal, have not reached end of for loop yet.
                addi $v0, $0 1 #loads r.v. of 1 into register
                jr $ra #exit the function


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

  print_big: #takes in and prints out a big integer in little endian format

          .text
          lw $t0 ($a0) #load b.n from memory. c = b->n
          addi $t1, $a0, 4 #Load address of b.digits[0]
  .loop1: addi $t0, $t0, -1 #get c by subtracting one from b.n. c -= 1 or c = b.n-1
          sll $t2, $t0, 2 #Calculate offset by shifting left twice, or multiplying by 4.
          add $t3, $t2, $t1 #calculate the address of b.digits[0 + c]
          lw $a0, ($t3)  # Load integer at address b.digits[0 + c] to printing register
          li $v0, 1 #load print int number code for sys call
          syscall #call the print statement
          bne $t0, $0, .loop1 #if c is equal to 0, I know I'm done
          jr $ra #exit the function

shift_right:

              .text
              lw $t0 ($a0) #i = a->n. grab a->n and store in $t0
              addi $t1, $a0, 4 #put address a.digits[0] in $t1
              addi $t2, $t0, 1 #store a->n += 1, while we have this value in register.
              sw $t2, ($a0) #writes new a->n value to memory
       .loop3: sll $t2, $t0, 2 #convert i to byte offset, load into register t3
              addi $t0, $t0, -1 #i = i - 1.
              sll $t3, $t0, 2 #convert i - 1 to byte offset, load into register t4
              add $t4, $t1, $t3 #calculate address of a->digits[i - 1]
              lw $t3, ($t4) #a->digits[i - 1] (no longer need i - 1, so use it's register)
              add $t4, $t1, $t2 #calculate address of a->digits[i]
              sw $t3, ($t4) #a->digits[i] = a->digits[i-1]
              bne $t0, $0, .loop3 #jump back up if i is not zero
              sw $0, ($t1) #set a->digits[$t1] to be 0.
              jr $ra #exit

  shift_left:
        .text
        lw $t0 ($a0) #grab a->n and store in $t0
        addi $t1, $a0, 4 #put address a[0] in $t1
        move $t2, $0 #i = 0
  .loop4: sll $t3, $t2, 2 #shifts i into byte offset
        addi $t2, $t2, 1 #i += 1
        sll $t4, $t2, 2 #shifts i + 1 into byte offset
        add $t4, $t4, $t1 #calculate address of a->digits[i + 1], store in t4
        lw $t4, ($t4) #save value of a->digits[i + 1] in t3
        add $t3, $t3, $t1 #calculate address of a->digits[i], store in t3
        sw $t4, ($t3) #a->digits[i] = a->digits[i + 1]
        bne $t0, $t2, .loop4 # if i != a->n, jump back up to loop
        addi $t0, $t0, -1 #Calculate a->n - 1
        sw $t0, ($a0) #store it
        #shift_left complete, now just need to call compress
        addi $sp, $sp, -4
        sw $ra, ($sp)
        jal compress #call compress on (a). $a0 still has reference to Bigint a
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
