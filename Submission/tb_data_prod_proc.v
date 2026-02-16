`timescale 1ns / 1ps

module tb_data_proc();

    reg clk;
    reg rstn;
    wire [7:0] raw_pixel;
    wire       raw_valid;
    wire       proc_ready;
    wire [7:0] out_pixel;
    wire       out_valid;
    
    reg [1:0] mode_select;

    // 1. Data Producer Instance
    data_producer #(.IMAGE_SIZE(1024)) producer_inst (
        .sensor_clk(clk),
        .rst_n(rstn),
        .ready(proc_ready),
        .pixel(raw_pixel),
        .valid(raw_valid)
    );

    // 2. Data Processing Instance
    data_proc processor_inst (
        .clk(clk),
        .rstn(rstn),
        .pixel_in(raw_pixel),
        .mode(mode_select),
        .valid_in(raw_valid),
        .pixel_out(out_pixel),
        .valid_out(out_valid),
        .ready_out(proc_ready)
    );

    // 3. Clock Generation (10ns period)
    always #5 clk = ~clk;

    // 4. Multi-Mode Test Sequence
    initial begin
        clk = 0;
        rstn = 0;
        mode_select = 2'b00; // Start in Bypass

        #20 rstn = 1;
        
        // --- MODE 00: BYPASS 
        mode_select = 2'b00;
        #11000; 

        // --- MODE 01: INVERT 
        mode_select = 2'b01;
        #11000;

        // --- MODE 10: CONVOLUTION (Test for remaining image)
        mode_select = 2'b10;
        #11000; 

        $finish;
    end

endmodule
