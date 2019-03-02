# Michael LeMay (mjlemay)
# This is my p2 MIPS work

  .globl main

  .data
out_string:    .asciiz   "\nHello, World!\n"

  .text
main:
    li $v0, 4
    a $a0, out_string
    syscall
    li $v0, 10
    syscall

is_small_prime: #takes in integer p. Checks if p is prime

            .text
            li $t0, 2 #set i = 2
            addi $t1, $a0, -1 #save the value of p-1
    .loop0: div $a0, $t0 #p % i
            mfhi $t3 #get the mod value
            bne $t3, $0, .not_done0 #compares t3 to the zero register,
                                #jumps past exit if not done
            move $v0, $0 #zeroes the return value
            jr $ra #return from this subroutine
.not_done0: addi $t0, $t0 1
            bne $t0, $t1 .loop0 #If not equal, have not reached end of for loop yet.
            addi $v0, $0 1 #loads r.v. of 1 into register
            jr $ra #exit the function


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
        bne $t0, $0, .loop1 #if c is equal to zero, I know I'm done
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
      #note that I don't have to modify digits, changing n suffices


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
      lw $t1 4($a1) #put address a[0] in $t1
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
      addi $sp, $sp, -4 #shift stack pointer down to save $ra
      sw $ra, ($sp) #save ra
      jal compress #call compress on (a). $a0 still has reference to Bigint a
      lw $ra, 0($sp) #reload ra
      addi $sp, $sp, 4 #move stack pointer back up
      jr $ra


compare_big: #pointer to a in a0, pointer to b in b0
            .text
            sw $t0, ($a0) #a.n
            sw $t1, ($a1) #b.n
            beq $t0, $t1, .equal #if the two are equal, jump to the loop code
            slt $t2, $t0, $t1 #if a.n is less than b.n, put 1 into t2, otherwise 0
            bne $t2, $0, .no #Is a.n less than b.n, jump to less
    .one:  addi $v0, $0, 1 #a.n is greater than b.n, return 1
            j exit #jump to end
   .n_one:  addi $v0, $0, -1 #a.n is less than b.n, return -1
            j exit #jump to end
    .equal: addi $t1, $a0, 4 #save base address of a.digits
            addi $t2, $a1, 4 #save base address of b.digits
    .loop:  addi $t0, $t0, -1 #i = a.n - 1
            sll $t5, $t0, 2
            addi $t3, $t5, $t1 #address of a.digits[0 + i]
            addi $t4, $t5, $t2 #address of b.digits[0 + i]
            sw $t3, ($t3) #value of a.digits[0 + i]
            sw $t4, ($t4) #value of b.digits[0 + i]

            bne $t3, $t4, .notequal #if a.digits[i] == b.digits[i], skip back to the top
            bne $t0, $0, .loop #if i != 0, jump back up to start of loop
            move $v0, $0 #set return value to zero
            jr $ra #exit
.notequal:  slt $t5, $t3, $t4
            bne $t5, $0, .less
            j .more
    .exit:  jr $ra #exit


add_big:
            .text
            sw $t0, ($a0) #a->n
            sw $t1, ($a1) #b->n
            addi $t5, $a0, 4 #address of a[0]
            addi $t6, $a1, 4 #address of b[0]
            addi $t7, $a2, 4 #address of c[0]
            slt $t2, $t0, $t1 #a->n < b->n
            beq $t2, $0, .b_small #if a.n > b->n, jump to b_small
            move $t2, $t1 #a smaller, set c->n = b->n
            j .incr_c #jump past next instruction
  .b_small: move $t2, $t0 #b smaller, set c->n = a->n
   .incr_c: addi $t2, $t2, 1 #c->n = c->n + 1
            sw $t2, ($a2) #save c->n value to memory
            move $t3, $0 #i = 0
  .clear_c: sll $t4, $t3, 2 #convert i to byte offset of i
            add $t4, $t4, $t7 #calculate address c->digits[i]
            sw $0, ($t4) #zeroes out this slot in memory
            addi $t3, $t3, 1
            bne $t3, $t2, .clear_c #If i < c->n, restart loop
            addi $sp, $sp, -12 #save s registers for use below
            sw $s0, ($sp)
            sw $s1, 4($sp)
            sw $s2, 8($sp)
            move $t5, $0 #carrying = 0
            move $t3 $0 #i = 0
    .loop:  sll $t4, $t3, 2 #convert i to the byte offset of i
            move $s0, $0 #a_val = 0
            slt $t6, $t3, $t0 #check if i is already past a->n
            beq $0, $t6, .be
            add $t6, $a0, $t4 #address of a->digits[i] - 4
            lw $s0, 4($t6) #a_val = a->digits[i]
      .be:  move $s1, $0 #b_val = 0
            slt $t6, $t3, $t1 #check if i is already past b->n
            beq $0, $t6, .c
            add $t6, $a1, $t4 #address of b->digits[i] - 4
            lw $s1, 4($t6) #b_val = b->digits[i]
       .c:  add $s2, $a2, $t4 #address of c->digits[i] - 4
            add $t6, $s0, $s1 #sum = a_val + b_val
            add $t6, $t6, $t5 #sum += carrying
            addi $t7, $0, 10 #puts ten in the register
            div $t6, $t7 #sum / 10 and sum % 10
            mflo $t5 #carrying = sum / 10
            mfhi $t6 #get sum % 10
            sw $t6, 4($s2) #c->digits[i] = sum % 10
            addi $t3, $t3, 1 #i += 1
            bne $t3, $t2, .loop #jump back up
            lw $s0, ($sp) #restore the s registers
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            addi $sp, $sp, 12 #reset stack pointer
            addi $sp, $sp, -4 #shift stack pointer down to save $ra
            sw $ra, ($sp) #save ra
            move $t0, $a0 #save address of a
            move $a0, $a2 #move address of c into the first parameter register
            jal compress #call compress on (c)
            move $a0, $t0
            lw $ra, 0($sp) #reload ra
            addi $sp, $sp, 4 #move stack pointer back up
            jr $ra


mult_big:
            .text
            sw $t0, ($a0) #a->n
            sw $t1, ($a1) #b->n
            add $t2, $t0, $t1 # c->n
            sw $t2, ($a2) #save c->n value to memory.
            move $t3, $0 #i = 0
  .clear_c: sll $t4, $t3, 2 #convert i to byte offset of i
            add $t4, $t4, $a2 #calculate address c->digits[i] - 4
            sw $0, 4($t4) #zeroes out c->digits[i] in memory
            addi $t3, $t3, 1 #increment i
            bne $t3, $t2, .clear_c #If i < c->n, restart loop
            #now done with t2, can reuse
            #save s registers

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
            mult $t6, $t6, $t7 #b.digits[i] * a.digits[j - i]
            add $t6, $t4, $t6 #carry + (b.digits[i] * a.digits[j - i])
            sll $t7, $t5, 2 #set t7 to byte offset of j
            add $t7, $a2, $t7 #calculate address of c.digits[i] - 4
            lw $t2, 4($t7) #get value at c.digits[j]
            add $t6, $t2, $t6 #c.digits + (b.digits[i] * a.digits[j - i]) + carry
            addi $t2, $0, 10 #put ten in s0
            div $t6, $t2 #val / 10 and val % 10
            mflo $t4 #carry = val / 10
            mfhi $t2 #val % 10
            sw $t2, 4($t7) #c.digits = val % 10
            addi $t5, $t5, 1 #j++
            bne $t5, $a3, .j_loop
            #end of j loop
            slt $t5, $0, $t4 #if carry > 0, t5 will be 1
            beq $t5, $0, .finish_up
            lw $t2, 4($t7) #get the value of c.digits[j]
            add $t5, $t2, $t4 #val = c.digits[j] + carry
            addi $t6, $0, 10 #sets t6 to ten
            div $t5, $t6 #val / 10
            mfhi $t6 #val % 10
            sw $t6, 4($t7) #c.digits[j] = val % 10
.finish_up: addi $t3, $t3, 1 #i++
            bne $t3, $t1, .i_loop #If i < b.n, restart loop
            #done with loops just compress and finish
            addi $sp, $sp, -4 #shift stack pointer down to save $ra
            sw $ra, ($sp) #save ra
            move $t0, $a3 #save bigint a in t0
            move $a0, $a2 #move bigint c into a
            jal compress #call compress on (a). $a0 still has reference to Bigint a
            move $a0, $a3 #reset a0
            lw $ra, 0($sp) #reload ra
            addi $sp, $sp, 4 #move stack pointer back up
            jr $ra

pow_big:#a0 has a, #a1 has result b, #a2 has p
                .text
                addi $sp, $sp, -8 #shift stack pointer down to save $ra and $s0
                sw $s0, 4($sp) #save s0 on stack
                sw $ra, ($sp) #save ra for future function call
                move $s0, $a2 #put p into s0
                move $t0, $0 #i = 0
                lw $t4, ($a0) #grab a.n
                sw $t4, ($a1) #set b.n = a.n
   .set_b_loop: sll $t5, $t0, 2 #byte offset of this current i
                add $t7, $t5, $a0 #calculate address for a.digits[i] - 4
                lw $t6, 4($t7) #get a.digits[i]
                add $t7, $t5, $a1 #calculate address for b.digits[i] - 4
                sw $t6, 4($t7) #b.digits[i] = a.digits[i]
                addi $t0, $t0, 1 #i++
                bne $t0, $t4, .set_b_loop
                addi $t0, $0, 1 #i = 1
                move $a2, $a1 #set b to be the third parameter
         .loop: jal mult_big #call mult big with (a, b, b)
                addi $t0, $t0, 1 #i++
                bne $t0, $s0, .loop #if i != p, jump back up to loop
                lw $s0, 4($sp)
                lw $ra, ($sp)
                addi $sp, $sp, 8 #shift stack pointer back up
                jr $ra


sub_big: #take in a, b, c
            .text
            lw $t0, ($a0) #saves a.n in t0
            lw $t1, ($a1) #saves b.n to t0
            sw $t0, ($a2) #c.n = a.n
            move $t2, $0 #i = 0
  .clear_c: sll $t3, $t2, 2 #convert i to byte offset of i
            add $t3, $t3, $a2 #calculate address c->digits[i]
            sw $0, 4($t4) #zeroes out this slot in memory
            addi $t2, $t2, 1
            bne $t2, $t0, .clear_c #If i < c->n, restart loop
            move $t2, $0 #i = 0
            move $t3, $0 #carried_last_time = 0
            move $t4, $0 #carry_this_time = 0




mod_big:
            .text
            move $t0, $0 #i = 0
            lw $t4, ($a0) #grab a.n
            sw $t4, ($a1) #set b.n = a.n
.set_b_loop: sll $t5, $t0, 2 #byte offset of this current i
            add $t7, $t5, $a0 #calculate address for a.digits[i] - 4
            lw $t6, 4($t7) #get a.digits[i]
            add $t7, $t5, $a1 #calculate address for b.digits[i] - 4
            sw $t6, 4($t7) #b.digits[i] = a.digits[i]
            addi $t0, $t0, 1 #i++
            bne $t0, $t4, .set_b_loop

LLT:
            .text



mersenne_scan:
            .text
            addi $s0, $0, 2 #p = 2
            addi $s1, $0, 550 #save 550
     .loop: loop_stuff
            bne $s0, $s1, .loop

            li $v0, 10
            syscall
