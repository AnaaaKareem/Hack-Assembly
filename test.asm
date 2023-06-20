// R0 -> store result
// R1 -> K0
// R2 -> P

@4
D=A

@i
M=D

(LOOP)
    // Check loop interation and decrement counter
    // ----------------------------------------------------------------------------------------
    @i
    D=M

    @END
    D;JEQ

    @i
    M=D-1
    // ----------------------------------------------------------------------------------------
    
    // Get Ri
    // ----------------------------------------------------------------------------------------
    // create mask for left 8 bits
    @255
    D=A

    // mask out Ri (last 8 bits)
    @R2
    D=D&M

    // save Ri to a variable
    @Ri
    M=D
    // ----------------------------------------------------------------------------------------

    // Get Li
    // ----------------------------------------------------------------------------------------

    // initialise Li with R2
    @R2
    D=M

    @Li
    M=D

    // rotate Li 8 times
    @8
    D=A

    @j
    M=D

    (ROTATE_Li)
        // check loop interation and decrement counter
        @j
        D=M

        // if j == 0 end the loop
        @MASK_Li
        D;JEQ

        // decrement counter
        @j
        M=M-1


        // load R3 memory from memory
        @Li
        D=M

        // check if leading bit is 1, i.e number is negative
        @NEGATIVE_BIT
        D; JLT
        
        // if the number if positive left shift by multiplying
        @Li
        D=M
        M=D+M

        @ROTATE_Li
        0;JMP


        (NEGATIVE_BIT)
            // if number is negative (leading bit is one)
            // left shift the number once and add a 1
            @Li
            D=M+1
            M=D+M
            @ROTATE_Li
            0; JMP

    (MASK_Li)
        // create mask for left 8 bits
        @255
        D=A

        // mask out Ri (last 8 bits)
        @Li
        D=D&M
        M=D
    // ----------------------------------------------------------------------------------------


    // Calculate Li1
    // ----------------------------------------------------------------------------------------
    @Ri
    D=M

    @Li+1
    M=D
    // ----------------------------------------------------------------------------------------


    // Calculate Ri+1
    // ----------------------------------------------------------------------------------------
    
    // calculate F(Ri, Ki)
    // --------------------------------------------
        // calculate !Ki
        @R1
        D=M

        @nKi
        M=!D

        // calculate Ri XOR nKi

        @Ri
        D=M

        @nKi
        D=D|M

        @A_OR_B // Ri | nKi
        M=D

        @Ri
        D=M

        @nKi
        D=D&M

        @NOT_A_AND_B
        M=!D

        @A_OR_B
        D=M

        @NOT_A_AND_B
        D=D&M

        @FRiKi
        M=D
    // --------------------------------------------

    // Calculate Li XOR F(Ri,Ki)
    // --------------------------------------------

        // calculate Ri XOR nKi
        @Li
        D=M

        @FRiKi
        D=D|M

        @A_OR_B // Ri | nKi
        M=D

        @Li
        D=M

        @FRiKi
        D=D&M

        @NOT_A_AND_B
        M=!D

        @A_OR_B
        D=M

        @NOT_A_AND_B
        D=D&M

        @Ri+1
        M=D
    // --------------------------------------------
    // ----------------------------------------------------------------------------------------

    // Combine the Li+1 and Ri+1 into P
    // ----------------------------------------------------------------------------------------
    // Left shift Li+1 8 times
    // --------------------------------------------
    
    // shift Li+1 8 times
    @8
    D=A

    @j
    M=D

    (LEFTSHIFT)
        // check loop interation and decrement counter
        @j
        D=M

        // if j == 0 end the loop
        @MASK_Li1
        D;JEQ

        // decrement counter
        @j
        M=M-1

        // left shift by multiplying
        @Li+1
        D=M
        M=D+M

        @LEFTSHIFT
        0;JMP


    (MASK_Li1)
        @Li+1
        D=M

        @R2
        M=D

        @Ri+1
        D=M

        @R2
        M=D|M
    // --------------------------------------------
    // ----------------------------------------------------------------------------------------


    // Calculate the new key
    // ----------------------------------------------------------------------------------------
    
    // if key == 0 rotate 2
    // else rotate 1

    (ROTATE_KEY)
        // load key from memory
        @R0
        D=M

        // check if leading bit is 1, i.e number is negative
        @NEGATIVE_BIT_KEY
        D; JLT
        
        // if the number if positive left shift by multiplying
        @R0
        D=M
        M=D+M

        (NEGATIVE_BIT_KEY)
            // if number is negative (leading bit is one)
            // left shift the number once and add a 1
            @Li
            M=D+M
            D=M+1
        
        @i
        D=M

        @keyNum
        D=D-1
        M=D

        @ROTATE_KEY
        D;JEQ
    // ----------------------------------------------------------------------------------------

    @LOOP
    0;JMP

@R2
D=M

@R0
M=D

(END)

    @END
    0;JMP