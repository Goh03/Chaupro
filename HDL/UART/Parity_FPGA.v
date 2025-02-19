module Parity_FPGA(
  input  wire        reset_n,     // Active low reset button
  input  wire [7:0]  SW,          // 8-bit switches for `data_in`
  input  wire [1:0]  BTN,         // 2 push buttons for `parity_type`
  output wire        LED          // Single LED for `parity_bit`
);

  // Internal signal declaration
  wire [7:0] data_in;
  wire [1:0] parity_type;
  wire parity_bit;

  // Map switches and buttons to module inputs
  assign data_in = SW;         // 8-bit switches as `data_in`
  assign parity_type = BTN;    // 2 push buttons as `parity_type`

  // Instantiate the Parity module
  Parity uut (
    .reset_n(reset_n),
    .data_in(data_in),
    .parity_type(parity_type),
    .parity_bit(parity_bit)
  );

  // Map output to LED
  assign LED = parity_bit;

endmodule
