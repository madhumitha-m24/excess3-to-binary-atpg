// ============================================================================
// File: excess3_to_binary.v
// Module: excess3_to_binary
// Project: 23ECE336 VLSI Testing and Testability
// Topic: Topic 18 - Excess-3 to Binary Converter
// Description: Structural gate-level netlist of a 4-bit Excess-3 to Binary
//              converter (B = E - 3). Designed exclusively using primitive
//              gates (NOT, AND, OR, XOR) for direct Cadence Modus ATPG ingestion.
// ============================================================================

`timescale 1ns / 1ps

module excess3_to_binary (
    input  [3:0] E,
    output [3:0] B
);

    // Internal Inverted Signal Wires
    wire not_e0;
    wire not_e1;
    wire not_e2;

    // Internal Product Term Wires
    wire w_e1_e0;
    wire w_e3_e2;
    wire w_e3_e1_e0;
    wire w_ne2_ne1;
    wire w_ne2_ne0;
    wire w_e2_e1_e0;

    // ------------------------------------------------------------------------
    // Primary Input Inverters
    // ------------------------------------------------------------------------
    not u_inv_e0 (not_e0, E[0]);
    not u_inv_e1 (not_e1, E[1]);
    not u_inv_e2 (not_e2, E[2]);

    // ------------------------------------------------------------------------
    // Bit 0 Formulation: B0 = ~E0
    // ------------------------------------------------------------------------
    not u_gate_b0 (B[0], E[0]);

    // ------------------------------------------------------------------------
    // Bit 1 Formulation: B1 = E1 ^ E0
    // ------------------------------------------------------------------------
    xor u_gate_b1 (B[1], E[1], E[0]);

    // ------------------------------------------------------------------------
    // Bit 2 Formulation: B2 = (~E2 & ~E1) | (~E2 & ~E0) | (E2 & E1 & E0)
    // ------------------------------------------------------------------------
    and u_and_e1_e0    (w_e1_e0,    E[1],   E[0]);
    and u_and_ne2_ne1  (w_ne2_ne1,  not_e2, not_e1);
    and u_and_ne2_ne0  (w_ne2_ne0,  not_e2, not_e0);
    and u_and_e2_e1_e0 (w_e2_e1_e0, E[2],   w_e1_e0);
    or  u_gate_b2      (B[2],       w_ne2_ne1, w_ne2_ne0, w_e2_e1_e0);

    // ------------------------------------------------------------------------
    // Bit 3 Formulation: B3 = (E3 & E2) | (E3 & E1 & E0)
    // ------------------------------------------------------------------------
    and u_and_e3_e2     (w_e3_e2,     E[3], E[2]);
    and u_and_e3_e1_e0  (w_e3_e1_e0,  E[3], w_e1_e0);
    or  u_gate_b3       (B[3],        w_e3_e2, w_e3_e1_e0);

endmodule
