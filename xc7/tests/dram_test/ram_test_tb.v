`ifndef VCDFILE
 `define VCDFILE "out.vcd"
`endif

module test;

   /* Inputs */
   /* Make a regular pulsing clock. */
   reg clk = 0;
   always #1 clk = !clk;
   reg nrst = 0;

   wire tx_baud_edge;
   wire rx_baud_edge;

   // Data in.
   wire [7:0] rx_data_wire;
   wire       rx_data_ready_wire;

   // Data out.
   wire       tx_data_ready;
   wire       tx_data_accepted;
   wire [7:0] tx_data;

   wire [5:0] write_address;
   wire [5:0] read_address;
   wire [0:0] read_data;
   wire [0:0] write_data;
   wire       write_enable;

   wire [0:0] rom_read_data;
   wire [5:0] rom_read_address;
   assign rom_read_data[0] = ^rom_read_address;

   wire       loop_complete;
   wire       error_detected;
   wire [7:0] error_state;
   wire [5:0] error_address;
   wire [0:0] expected_data;
   wire [0:0] actual_data;

   RAM_TEST #(
              .ADDR_WIDTH(6),
              .DATA_WIDTH(1),
              .IS_DUAL_PORT(1),
              .ADDRESS_STEP(1),
              // 64-bit LUT memories are 0-63
              .MAX_ADDRESS(63)
              ) dram_test (
                           .rst(!nrst),
                           .clk(clk),
                           // Memory connection
                           .read_data(read_data),
                           .write_data(write_data),
                           .write_enable(write_enable),
                           .read_address(read_address),
                           .write_address(write_address),
                           // INIT ROM connection
                           .rom_read_data(rom_read_data),
                           .rom_read_address(rom_read_address),
                           // Reporting
                           .loop_complete(loop_complete),
                           .error(error_detected),
                           .error_state(error_state),
                           .error_address(error_address),
                           .expected_data(expected_data),
                           .actual_data(actual_data)
                           );

   RAM64X1D #(
              .INIT(64'b01101001_10010110_10010110_01101001_10010110_01101001_01101001_10010110)
              ) dram(
                     .WCLK(clk),
                     .A5(write_address[5]),
                     .A4(write_address[4]),
                     .A3(write_address[3]),
                     .A2(write_address[2]),
                     .A1(write_address[1]),
                     .A0(write_address[0]),
                     .DPRA5(read_address[5]),
                     .DPRA4(read_address[4]),
                     .DPRA3(read_address[3]),
                     .DPRA2(read_address[2]),
                     .DPRA1(read_address[1]),
                     .DPRA0(read_address[0]),
                     .DPO(read_data[0]),
                     .D(write_data[0]),
                     .WE(write_enable)
                     );

   initial begin
      $dumpfile(`VCDFILE);
      $dumpvars(0, dram_test);
      #10000;
      $dumpflush;
      $finish;
   end

    always @(posedge clk) begin
        nrst <= 1;
    end

endmodule // test
