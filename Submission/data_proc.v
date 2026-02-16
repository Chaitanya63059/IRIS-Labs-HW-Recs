module data_proc(
    input  wire clk,
    input  wire rstn,
    input  wire [7:0] pixel_in,
    input  wire [1:0] mode,
    input  wire valid_in,
    output reg  [7:0] pixel_out,
    output reg  valid_out,
    output wire ready_out
);

// Line Buffers (store 32 pixels each)
reg [7:0] lb1 [0:31]; 
reg [7:0] lb2 [0:31];

// 3x3 Sliding Window
//  p11  p12  p13
//  p21  p22  p23
//  p31  p32  p33
reg [7:0] p11, p12, p13; 
reg [7:0] p21, p22, p23;
reg [7:0] p31, p32, p33;

integer i;

// RESET & SHIFT LOGIC
always @(posedge clk) begin
    if (!rstn) begin
        // Clear all buffers
        for (i = 0; i < 32; i = i + 1) begin
            lb1[i] <= 8'h00;
            lb2[i] <= 8'h00;
        end
        // Clear 3x3 window
        {p11,p12,p13,p21,p22,p23,p31,p32,p33} <= 72'h0;
    end 
    else if (valid_in && ready_out) begin
        // SHIFT LINE BUFFERS DOWN (vertical shift)
        lb1[0] <= pixel_in;
        for (i = 31; i > 0; i = i - 1) 
            lb1[i] <= lb1[i-1];
        
        lb2[0] <= lb1[31];
        for (i = 31; i > 0; i = i - 1) 
            lb2[i] <= lb2[i-1];
        
        // SHIFT 3x3 WINDOW RIGHT (horizontal shift)
        // Current row comes from input
        p31 <= pixel_in;  p32 <= p31;  p33 <= p32;
        
        // Middle row comes from lb1
        p21 <= lb1[31];   p22 <= p21;  p23 <= p22;
        
        // Top row comes from lb2
        p11 <= lb2[31];   p12 <= p11;  p13 <= p12;
    end
end

// Convolution, Fixed Weights
// Kernel:
//   -1   0   1
//   -1   0   1
//   -1   0   1
//
// Formula: RIGHT MOST COLUMN - LEFT MOST COLUMN
// = (p13 + p23 + p33) - (p11 + p21 + p31)
 
wire signed [15:0] convol_result;

assign convol_result = p13 + p23 + p33 - ( p11 + p21 + p31);


// OUTPUT PROCESSING
always @(posedge clk) begin
    if (!rstn) begin
        pixel_out <= 8'h00;
        valid_out <= 1'b0;
    end 
    else if (valid_in && ready_out) begin
        case (mode)
            2'b00: pixel_out <= pixel_in;              // Mode 0: Bypass (no processing)
            
            2'b01: pixel_out <= ~pixel_in;             // Mode 1: Invert
            
            2'b10: begin                               // Mode 2: Convolution
                // Handle negative values:
                // Take absolute value and scale to 0-255
                if (convol_result < 0)
                    pixel_out <= (~convol_result[7:0]) + 1'b1;  // 2's Complement
                else
                    pixel_out <= convol_result[7:0];             // Positive part
            end
            
            default: pixel_out <= pixel_in;
        endcase
        valid_out <= 1'b1;
    end 
    else begin
        valid_out <= 1'b0;
    end
end

assign ready_out = 1'b1;

endmodule