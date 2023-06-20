(BEGINNING)
//// Used to set variables for calculations ////
@16384 // 0100 0000 0000 0000
D=A    // Load lower 15-bits
D=D+A  // Left shift by 1
@16MSB // 16 bit Most Significant Bit
M=D // 1000 0000 0000 0000

// Used for calculations related to key rotation
@128
D=A
@8MSB // 8 bit Most Significant Bit
M=D

//// Used to set mask plaintext ////
// Used for masking right bits of the plaintext
@R2
D=M
@255
D=D&A
@RIGHT
M=D

// Used for masking left bits of the plaintext
@32640
D=A
D=D+A
@LEFTMASK
M=D
D=M
@R2
D=M&D
@LEFT
M=D

//// Used to Shift The Left Part To The Right To Perform Operations ////
@8
D=A
@LTORCOUNT
M=D

(LOOP)
@LTORCOUNT
D=M
@STOP_IF_ZERO
D;JEQ     // if D (counter) equals zero, jump to STOP_IF_ZERO

@LEFT
D=M
@16MSB
D=D&M
@SKIP
D;JEQ

@LEFT
D=M+1
M=M+D
@SUBCOUNT
0;JMP

(SKIP)
@LEFT
D=M
M=M+D

(SUBCOUNT)
// Subtract the LTORCOUNT by 1
@LTORCOUNT
D=M
M=D-1
// Loop back at the start
@LOOP
0;JMP     // jump to POWERLOOP to repeat the loop
(STOP_IF_ZERO)


//// Deriving all keys used in the operations ////
// Store the original key to K1 to be used for rotation later
@R1
D=M
@KEY1
M=D

// Derive K1
@KEY1
D=M
@8MSB
D=D&M
@SKIPK1
D;JEQ

// Rotate bit
@128
D=A
@KEY1
M=M-D
D=M
M=M+D
M=M+1
@DONEK1
0;JMP

// Shift Normally
(SKIPK1)
@KEY1
D=M
M=M+D
(DONEK1)

// Store the K1 to K2 to be used for rotation later 
@KEY1
D=M
@KEY2
M=D

// Derive K2
@KEY2
D=M
@8MSB
D=D&M
@SKIPK2
D;JEQ

// Rotate bit
@128
D=A
@KEY2
M=M-D
D=M
M=M+D
M=M+1
@DONEK2
0;JMP

// Shift bit
(SKIPK2)
@KEY1
D=M
M=M+D
(DONEK2)

@KEY2
D=M
@KEY3
M=D

// Derive K3 First Time
@KEY3
D=M
@8MSB
D=D&M
@SKIPK3.1
D;JEQ

// Rotate bit
@128
D=A
@KEY3
M=M-D
D=M
M=M+D
M=M+1
@DONEK3.1
0;JMP

// Shift bit
(SKIPK3.1)
@KEY3
D=M
M=M+D
(DONEK3.1)

// Derive K3 Second Time
@KEY3
D=M
@8MSB
D=D&M
@SKIPK3.2
D;JEQ

// Rotate bit
@128
D=A
@KEY3
M=M-D
D=M
M=M+D
M=M+1
@DONEK3.2
0;JMP

// Shift bit
(SKIPK3.2)
@KEY3
D=M
M=M+D
(DONEK3.2)

//// Start Round 1 ////

// Store Current Left to Previous Left (L0)
@LEFT
D=M
@L0
M=D

// Make new left from right
@RIGHT
D=M
@LEFT
M=D

//// Function for Right

// Negate the key
@R1
D=M
M=!D
@255
D=A
@R1
M=M&D

// Store the right part in register D
@RIGHT
D=M

// Perform an AND operation with the key and store the result in register D
@R1
D=D&M

// Store the result of the AND operation in memory location a buffer
@BUFFER1.1
M=D

// Reset register D to the right part again
@RIGHT
D=M

// Perform an OR operation with the key and store the result in register D
@R1
D=D|M

// Store the result of the OR operation in a second buffer
@BUFFER1.2
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.1
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.2
D=D&M
@RIGHT
M=D

// XOR Function and Previous Left //

// Store the first number in register D
@L0
D=M

// Perform an AND operation with the second number and store the result in register D
@RIGHT
D=D&M

// Store the result of the AND operation in memory location 0
@BUFFER1.3
M=D

// Reset register D to the first number
@L0
D=M

// Perform an OR operation with the second number and store the result in register D
@RIGHT
D=D|M

// Store the result of the OR operation in memory location 1
@BUFFER1.4
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.3
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.4
D=D&M
@RIGHT
M=D


//// Start Round 2 ////

// Store Current Left to Previous Left (L0)
@LEFT
D=M
@L0
M=D

// Make new left from right
@RIGHT
D=M
@LEFT
M=D

//// Function for Right

// Negate the key
@KEY1
D=M
M=!D
@255
D=A
@R1
M=M&D

// Store the right part in register D
@RIGHT
D=M

// Perform an AND operation with the key and store the result in register D
@KEY1
D=D&M

// Store the result of the AND operation in memory location a buffer
@BUFFER1.1
M=D

// Reset register D to the right part again
@RIGHT
D=M

// Perform an OR operation with the key and store the result in register D
@KEY1
D=D|M

// Store the result of the OR operation in a second buffer
@BUFFER1.2
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.1
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.2
D=D&M
@RIGHT
M=D

// XOR Function and Previous Left //

// Store the first number in register D
@L0
D=M

// Perform an AND operation with the second number and store the result in register D
@RIGHT
D=D&M

// Store the result of the AND operation in memory location 0
@BUFFER1.3
M=D

// Reset register D to the first number
@L0
D=M

// Perform an OR operation with the second number and store the result in register D
@RIGHT
D=D|M

// Store the result of the OR operation in memory location 1
@BUFFER1.4
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.3
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.4
D=D&M
@RIGHT
M=D


//// Start Round 3 ////

// Store Current Left to Previous Left (L0)
@LEFT
D=M
@L0
M=D

// Make new left from right
@RIGHT
D=M
@LEFT
M=D

//// Function for Right

// Negate the key
@KEY2
D=M
M=!D
@255
D=A
@R1
M=M&D

// Store the right part in register D
@RIGHT
D=M

// Perform an AND operation with the key and store the result in register D
@KEY2
D=D&M

// Store the result of the AND operation in memory location a buffer
@BUFFER1.1
M=D

// Reset register D to the right part again
@RIGHT
D=M

// Perform an OR operation with the key and store the result in register D
@KEY2
D=D|M

// Store the result of the OR operation in a second buffer
@BUFFER1.2
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.1
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.2
D=D&M
@RIGHT
M=D

// XOR Function and Previous Left //

// Store the first number in register D
@L0
D=M

// Perform an AND operation with the second number and store the result in register D
@RIGHT
D=D&M

// Store the result of the AND operation in memory location 0
@BUFFER1.3
M=D

// Reset register D to the first number
@L0
D=M

// Perform an OR operation with the second number and store the result in register D
@RIGHT
D=D|M

// Store the result of the OR operation in memory location 1
@BUFFER1.4
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.3
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.4
D=D&M
@RIGHT
M=D


//// Start Round 4 ////

// Store Current Left to Previous Left (L0)
@LEFT
D=M
@L0
M=D

// Make new left from right
@RIGHT
D=M
@LEFT
M=D

//// Function for Right

// Negate the key
@KEY3
D=M
M=!D
@255
D=A
@R1
M=M&D

// Store the right part in register D
@RIGHT
D=M

// Perform an AND operation with the key and store the result in register D
@KEY3
D=D&M

// Store the result of the AND operation in memory location a buffer
@BUFFER1.1
M=D

// Reset register D to the right part again
@RIGHT
D=M

// Perform an OR operation with the key and store the result in register D
@KEY3
D=D|M

// Store the result of the OR operation in a second buffer
@BUFFER1.2
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.1
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.2
D=D&M
@RIGHT
M=D

// XOR Function and Previous Left //

// Store the first number in register D
@L0
D=M

// Perform an AND operation with the second number and store the result in register D
@RIGHT
D=D&M

// Store the result of the AND operation in memory location 0
@BUFFER1.3
M=D

// Reset register D to the first number
@L0
D=M

// Perform an OR operation with the second number and store the result in register D
@RIGHT
D=D|M

// Store the result of the OR operation in memory location 1
@BUFFER1.4
M=D

// Negate the result of the AND operation and store it in register D
@BUFFER1.3
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@BUFFER1.4
D=D&M
@RIGHT
M=D

// Shift the left back to its place
@LEFT
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D
D=M
M=M+D

// Check If value is changed if false don't store value again and get back to the beginning
@R0
D=M
@BEGINNING
D;JNE

// OR Left and Right
@RIGHT
D=M
@LEFT
D=M|D
@R0
M=D
@BEGINNING
0;JMP