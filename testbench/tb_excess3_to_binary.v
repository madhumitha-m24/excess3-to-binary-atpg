// ============================================================================
// File: tb_excess3_to_binary.v
// Module: tb_excess3_to_binary
// Project: 23ECE336 VLSI Testing and Testability
// Topic: Topic 18 - Excess-3 to Binary Converter
// Description: Self-checking testbench applying all 16 input combinations
//              (0000 to 1111). Validates B = E - 3 for valid Excess-3 inputs
//              (0011 to 1100) and displays don't-care responses for invalid inputs.
// ============================================================================

`timescale 1ns / 1ps

module tb_excess3_to_binary;

    // Testbench Stimulus and Monitored Signals
    reg  [3:0] E;
    wire [3:0] B;

    // Verification Tracking Variables
    integer i;
    integer pass_count;
    integer fail_count;
    reg [3:0] expected_B;

    // Unit Under Test (UUT) Instantiation
    excess3_to_binary uut (
        .E(E),
        .B(B)
    );

    initial begin
        // Initialize VCD dump for waveform visualization
        $dumpfile("tb_excess3_to_binary.vcd");
        $dumpvars(0, tb_excess3_to_binary);

        pass_count = 0;
        fail_count = 0;
        E = 4'b0000;

        $display("================================================================================");
        $display(" 23ECE336 VLSI Testing and Testability - Topic 18 Verification");
        $display(" Circuit: 4-Bit Excess-3 to Binary Converter (B = E - 3)");
        $display("================================================================================");
        $display(" Index | E (Binary) | E (Dec) | B (Binary) | B (Dec) | Expected | Verification");
        $display("-------+------------+---------+------------+---------+----------+---------------");

        // Iterate through all 16 possible 4-bit combinations
        for (i = 0; i < 16; i = i + 1) begin
            E = i[3:0];
            #10; // Propagation delay settling window

            if (i >= 3 && i <= 12) begin
                // Valid Excess-3 range: 3 <= E <= 12 corresponds to Decimal 0 <= B <= 9
                expected_B = i[3:0] - 4'd3;

                if (B === expected_B) begin
                    pass_count = pass_count + 1;
                    $display("  %2d   |    %4b    |   %2d    |    %4b    |   %2d    |   %4b   | PASS",
                             i, E, i, B, B, expected_B);
                end else begin
                    fail_count = fail_count + 1;
                    $display("  %2d   |    %4b    |   %2d    |    %4b    |   %2d    |   %4b   | FAIL (MISMATCH)",
                             i, E, i, B, B, expected_B);
                end
            end else begin
                // Invalid Excess-3 inputs (don't-care states)
                $display("  %2d   |    %4b    |   %2d    |    %4b    |   %2d    |   XXXX   | DONT CARE",
                         i, E, i, B, B);
            end
        end

        $display("================================================================================");
        $display(" SIMULATION EXECUTION SUMMARY");
        $display("================================================================================");
        $display(" Total Vectors Tested      : 16");
        $display(" Valid Patterns Checked    : 10 (Excess-3: 0011 to 1100)");
        $display(" Don't Care States Applied : 6  (States 0, 1, 2, 13, 14, 15)");
        $display(" Passed Assertions         : %0d", pass_count);
        $display(" Failed Assertions         : %0d", fail_count);
        $display("================================================================================");

        if (fail_count == 0 && pass_count == 10) begin
            $display(" TEST RESULT: PASSED - All functional operations verified with zero errors.");
        end else begin
            $display(" TEST RESULT: FAILED - Detected functional discrepancies in converter output.");
        end
        $display("================================================================================");

        $finish;
    end

endmodule
