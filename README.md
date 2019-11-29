# Memory-Game-
FPGA prototyping of Memory Game 

Memory Game implementation on Zedboard. The specs of the game are: i)
After dumping the bit file to FPGA player will press a push button to start the game and to restart the
game there should be one push button. ii) Then every 2 second interval 4-bit random number will glow
(every time player plays the game random numbers should be different). iii) After showing the number
all the 8 Leds should blink once to show that program is now ready to accept the input. iv) Player have
to give the number using switches presenter on the FPGA board one by one. v) Finally, if all the inputs
are correct with the correct sequence then board will show "WIN" by glowing all the Led (means
8'b1111_1111) & if all the inputs are correct but sequence is wrong then board will show "DRAW" by
glowing alternate Leds (means 8'b1010_1010) & if entered numbers are wrong then no Leds will glow.
