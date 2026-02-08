# PART A

## Question 1
The issue with synchronizing the data bits independently is about the skew, as we can see from the waveform given ,there is a delay of 1 clock cycle (Aclk) for b[1] and b[2], but b[0] already becomes 1 before itself as it changes before Aclk's posedge ,therefore the input to the decoder changes. If there is no skew, the input to the decoder should go like 000 to 111 , but here we will see an intermediate value 001 which is not supposed to be seen, this changes the output of the decoder.

## Question 2
This skew causes an intermediate value because, b[0] becomes 1 before posedge of Aclk, so the flipflop A00 takes input as 1 , while A10,A20 will take 0 as their input, metastability will not be an issue because 2FF- Synchronizer is used and the second flip flops give enough time for metastability to settle down, but this does not handle the skew, so basically the input to the decoder becomes 001(invalid intermediate value).

## Question 3
The fundamental mistake I feel is that multiple bit sampling is not considered ,single bit sampling is only considered and when an input depends on all three bits ,we should treat it as a data bus and when we do that, we should ensure all bits are in sync with each other, as the the output depends on all bits collectively.

## Question 4
### Solution 1: Handshake Mechanism
Which basically consists request and acknowledgment signals, the acknowledgment signal can be sent once the data is received at the input of the decoder, takes more number of clk cycles for the request signal to reach, by that time the input becomes 111.

### Solution 2: Asynchronous FIFO
Uses gray code pointers(read and write), these pointers have their own clock domains. On reset, both pointers are cleared and the FIFO is empty and hence the FIFO is not full, we use the not-full signal to indicate that the FIFO is ready to receive a data. After data is put into the FIFO the write ptr toggles when the FIFO becomes full, another signal is sent so that data will not be written.

### Solution 3: Toggle based Mechanism
This technique detects the data change ,samples only when the data is stable for few(2) clk cycles ,so skew is addressed.(The issue is, this is only applicable for this particular example, for fast data changes, this is not a feasible solution)
