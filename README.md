# Fiestal Encryption

This project uses hack assembly language to implement a Fiestal encryption algorithm based on an XOR gate and a Rotater. The project requires the software from nand2tetris, which includes the Assembler and the Simulator.

## XOR Gate

The XOR gate takes two 16-bit values from RAM[3] and RAM[4] and performs a bitwise exclusive OR operation on them. The result is stored in RAM[5].

## Rotater

The Rotater takes a 16-bit value from RAM[3] and rotates it to the left by the number of bits specified in RAM[4]. The result is stored in RAM[5].

## Fiestal Encryption

The Fiestal encryption algorithm uses four keys K0, K1, K2, and K3, which are derived from a 16-bit original key stored in RAM[1]. Each key is rotated once, except for K0 which is not rotated and K3 which is rotated twice. The algorithm splits a 16-bit message stored in RAM[2] into two 8-bit numbers Li and Ri. Then, it applies the following function four times:

Li+1 = Ri
Ri+1 = Li ⊕ F(Ri, Ki)

where F(A, B) = A ⊕ ¬B is a bitwise function that takes two 8-bit numbers as inputs and returns an 8-bit number as output. The final encrypted message is stored in RAM[0] as Ri+1Li+1.

## How to run the project

To run the project, follow these steps:

1. Open the Assembler and load the file `project.asm`.
2. Open the Simulator and load the file `project.tst`.
3. Run the test script and check the output window for any errors or mismatches.

## How to test the project

To test the project, you need to have a `.tst` file that loads the `.asm` file and sets the input values for RAM[1] and RAM[2]. You also need to have a `.cmp` file that contains the expected output value for RAM[0]. The files should have the same name as the project file. For example, if your project file is `project.asm`, then your test file should be `project.tst` and your comparison file should be `project.cmp`.

## Author

This project was created by Karim Amr Elsayed Khater.

## Future fixes

The Fiestal encryption algorithm is not working properly and needs to be fixed. The possible causes are:

- A bug in the XOR gate or the Rotater implementation.
- A mistake in the Fiestal encryption logic or function.

## License

This project is unlicensed and free to use or modify.
