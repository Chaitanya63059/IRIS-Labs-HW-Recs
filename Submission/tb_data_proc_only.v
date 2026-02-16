`timescale 1ns/1ps
module tb_data_proc();
    reg clk;
    reg rstn;
    reg [7:0] pixel_in;
    reg [1:0] mode;
    reg valid_in;
    wire [7:0] pixel_out;
    wire valid_out;
    wire ready_out;
    
    // Image memory
    reg [7:0] image_mem [0:1023];
    integer i;
    integer output_count;
    
    // Data Processing Instance
    data_proc processor_inst (
        .clk(clk),
        .rstn(rstn),
        .pixel_in(pixel_in),
        .mode(mode),
        .valid_in(valid_in),
        .pixel_out(pixel_out),
        .valid_out(valid_out),
        .ready_out(ready_out)
    );
    
    // Clock Generation
    always #5 clk = ~clk;
    
    // Monitor outputs
    always @(posedge clk) begin
        if (valid_out) begin
            output_count = output_count + 1;
        end
    end
    
    // Load image from hex file
    initial begin
        $readmemh("image.hex", image_mem);
    end
    
    // Test Sequence
    initial begin
        clk = 0;
        rstn = 0;
        valid_in = 0;
        pixel_in = 0;
        mode = 2'b00;
        output_count = 0;
        
        #20 rstn = 1;
        
        // --- MODE 00: BYPASS ---
        mode = 2'b00;
        output_count = 0;
        for (i = 0; i < 1024; i = i + 1) begin
            @(posedge clk);
            pixel_in = image_mem[i];
            valid_in = 1'b1;
        end
        valid_in = 1'b0;
        #3000;
        
        // --- MODE 01: INVERT ---
        mode = 2'b01;
        output_count = 0;
        for (i = 0; i < 1024; i = i + 1) begin
            @(posedge clk);
            pixel_in = image_mem[i];
            valid_in = 1'b1;
        end
        valid_in = 1'b0;
        #3000;
        
        // MODE 10: CONVOLUTION
        mode = 2'b10;
        output_count = 0;
        for (i = 0; i < 1024; i = i + 1) begin
            @(posedge clk);
            pixel_in = image_mem[i];
            valid_in = 1'b1;
        end
        valid_in = 1'b0;
        #3000;
        
        $finish;
    end
endmodule