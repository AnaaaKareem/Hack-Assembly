// This file is adapted from www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/mult/Mult.tst

load XOR.asm,
output-file XOR.out,
compare-to XOR.cmp,
output-list RAM[5]%D2.6.2;

set RAM[3] 0,   // Set test arguments
set RAM[4] 0,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;

set RAM[3] 0,   // Set test arguments
set RAM[4] 1,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;

set RAM[3] 1,   // Set test arguments
set RAM[4] 0,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;

set RAM[3] 1,   // Set test arguments
set RAM[4] 1,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;

set RAM[3] 32556,   // Set test arguments
set RAM[4] 2763,
set RAM[5] 0,
repeat 100 {
  ticktock;
}
output;