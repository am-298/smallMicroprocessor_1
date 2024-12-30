module tb_microprocessor;

  // Inputs
  reg clk;
  reg sys_rst;
  reg [15:0] din;

  // Outputs
  wire [15:0] dout;

  // Instantiate the microprocessor
  microprocessor uut (
    .clk(clk),
    .sys_rst(sys_rst),
    .din(din),
    .dout(dout)
  );

  // Clock generation
  always begin
    #5 clk = ~clk; // Generate clock with a period of 10 time units
  end

  // Test sequence
  initial begin
    // Initialize Inputs
    clk = 0;
    sys_rst = 1;  // Apply reset
    din = 16'h0000;  // Initialize din to 0

    // Wait for reset to propagate
    #10;
    sys_rst = 0;  // Release reset

    // Stimulate the microprocessor
    // Example: Set instruction memory and data memory
    // First, load an instruction into the instruction memory
    uut.inst_mem[0] = 32'h00000001; // Example instruction

    // Simulate some data
    uut.data_mem[0] = 16'h1234;

    // Trigger the processor for a few cycles
    #20;
    // Set some values in din and observe dout
    din = 16'h5678;  // Set din to some value
    #20;
    din = 16'h9ABC;  // Change din value and observe dout
    #20;

    // Test halt condition
    uut.stop = 1'b1;  // Set the stop flag for halt condition
    #10;

    // Test jump instruction (example)
    uut.PC = 5;  // Set a specific PC value
    uut.jmp_flag = 1'b1;  // Trigger jump flag
    #20;

    // Final check, print dout value
    #10;
    $display("Output dout: %h", dout);

    // End simulation
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("At time %t, dout = %h", $time, dout);
  end

endmodule
