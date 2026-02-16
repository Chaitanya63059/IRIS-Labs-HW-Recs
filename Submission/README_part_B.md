# Task B 

## Data Producing Block
In this block, there was a line of code $readmemh(image.hex ,image_mem) , so I have taken a random picture from internet , converted into a hex file which is uploaded.

## Data Processing Block 
Here I have made an Fifo based 2-line buffers for the input data.
For Convolution, I have considered a simple Kernel (for edge detection) , which I have mentioned in the verilog code 'data_proc.v'.

## Architecture Overview

### Data Flow
```
┌─────────────┐
│   Pixel In  │
│ (image.hex) │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Line Buffer 1  |
│  FIFO based     | 
└──────┬──────────┘
       │
       ▼
┌────────────────┐
│  Line Buffer 2 |
│  FIFO based    |            
└──────┬─────────┘
       │
       ▼
┌────────────────────────────┐
│   3×3 Sliding Window       │
│  p11  p12  p13             │
│  p21  p22  p23             │
│  p31  p32  p33             │
└──────┬─────────────────────┘
       │
       ├─────────────┬──────────────┐
       │             │              │
       ▼             ▼              ▼
   Bypass      Invert (NOT)   Convolution
   (Mode 0)    (Mode 1)       (Mode 2)
       │             │              │
       └─────────────┼──────────────┘
                     │
                     ▼
           ┌──────────────────┐
           │  Output Mux      │
           │  (Select Mode)   │
           └────────┬─────────┘
                    │
                    ▼
            ┌────────────────┐
            │  Pixel Out     │
            │  Valid Out     │
            └────────────────┘
```

## Firmware.c
Boot Sequence: The start.s assembly initializes the stack pointer to 0x20000 and clears the .bss section before jumping to the C main().

Memory Mapped I/O : The C firmware controls the hardware by writing to specific register addresses:

REG_MODE (0x03000000): Sets the processing mode.

REG_PIXEL_OUT (0x03000008): Reads the processed pixel.

Execution Flow: The firmware sequentially iterates through all 1024 pixels for each mode, printing the hex results via UART for verification in the simulation.


