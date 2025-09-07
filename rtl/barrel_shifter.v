// Define a parameterized barrel shifter module
module barrel_shifter#(
    parameter DATA_WIDTH        = 64,  // Width of the input/output data (default: 64 bits)
    parameter DIRECTION         = 0,   // Direction of the shift (0: left, 1: right, unused in this implementation)
    parameter SIZE              = 8,   // Size of the basic unit for shifting (default: 8 bits, i.e., byte)
    parameter BYTE_WIDTH        = DATA_WIDTH/SIZE,  // Number of basic units (e.g., bytes) in the data
    parameter OFFSET_WIDTH      = $clog2(BYTE_WIDTH) // Width of the offset input (log2 of BYTE_WIDTH)
)(
    input  [DATA_WIDTH-1:0]      i_data,          // Input data to be shifted
    input  [OFFSET_WIDTH-1:0]    i_byte_offset,   // Offset for shifting (in units of SIZE, e.g., bytes)
    output [DATA_WIDTH-1:0]      o_data           // Output data after shifting
);

// Define the number of stages in the barrel shifter (equal to OFFSET_WIDTH)
localparam BS_LEVEL = OFFSET_WIDTH;

// Declare arrays to hold intermediate results

wire [DATA_WIDTH-1:0]   stages     [BS_LEVEL:0]     ; // stages[i] holds the data after the i-th stage of shifting
wire [DATA_WIDTH*2-1:0] mdl_stages [BS_LEVEL-1:0]   ; // mdl_stages[i] holds concatenated data for the i-th stage (double the width of DATA_WIDTH)

// Initialize the last stage with the input data
assign stages[BS_LEVEL] = i_data;
// Initialize the last mdl_stages with concatenated input data (for cyclic shift)
assign mdl_stages[BS_LEVEL-1] = {i_data, i_data};

// Declare a generate variable for loop iteration
genvar i;

// Generate the barrel shifter stages
generate
    // Loop to create each stage of the barrel shifter
    for(i = BS_LEVEL-1; i >= 0; i = i-1) begin:GEN_BS_LEVEL
        // Conditional assignment for each stage:
        // If the i-th bit of i_byte_offset is set, shift the data by (1<<i)*SIZE bits (left rotation)
        // Otherwise, pass the data through without shifting
        assign stages[i] = (i_byte_offset[i] == 1'b1) ?
            mdl_stages[i][(1<<i)*SIZE +: DATA_WIDTH] :  // Select shifted data
            mdl_stages[i][DATA_WIDTH-1:0];              // Select unshifted data
    end

    for(i = BS_LEVEL-1; i > 0; i = i-1) begin:GEN_MDL_BS_LEVEL
        // Concatenate the output of the current stage with itself for the next stage
        // This allows for cyclic shifting
        assign mdl_stages[i-1] = {stages[i], stages[i]};
    end
endgenerate

// Assign the final output to the result of the last stage
assign o_data = stages[0];

endmodule
