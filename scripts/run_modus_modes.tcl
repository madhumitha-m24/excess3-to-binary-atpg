# ==============================================================================
# File: run_modus_modes.tcl
# Tool: Cadence Modus DFT Software
# Project: 23ECE336 VLSI Testing and Testability
# Topic: Topic 18 - Excess-3 to Binary Converter
# Description: Automated evaluation and comparison of ATPG fault simulation
#              modes in Cadence Modus:
#                1. High-Speed Scan (HS)  : Fast, single-pattern test generation
#                2. General Purpose (GP)  : Balanced 3-pattern test generation
#                3. Multi-Pass (MP)       : Comprehensive 5-pattern test generation
# ==============================================================================

# ------------------------------------------------------------------------------
# Phase 1: Environment and Model Initialization
# ------------------------------------------------------------------------------
# Build the structural gate-level model from RTL source.
build_model -designsource rtl/excess3_to_binary.v

# Establish the full-scan / combinational test mode.
build_testmode -testmode FULLSCAN

# Verify testability structures and scan chains.
verify_test_structures -testmode FULLSCAN

# Build the baseline single stuck-at fault model.
build_faultmodel

# ------------------------------------------------------------------------------
# Phase 2: Experiment 1 - High-Speed Scan (HS) Strategy
# ------------------------------------------------------------------------------
# High-Speed scan focuses on rapid pattern generation with minimal pattern budget.
# Constrained to 1 pattern to evaluate single-vector fault coverage efficiency.
create_logic_tests -testmode FULLSCAN -experiment HS -maxpatterns 1
report_fault_statistics -testmode FULLSCAN -experiment HS

# ------------------------------------------------------------------------------
# Phase 3: Experiment 2 - General Purpose (GP) Strategy
# ------------------------------------------------------------------------------
# General Purpose mode balances execution speed, compaction, and test quality.
# Allocated a 3-pattern budget for progressive fault detection.
create_logic_tests -testmode FULLSCAN -experiment GP -maxpatterns 3
report_fault_statistics -testmode FULLSCAN -experiment GP

# ------------------------------------------------------------------------------
# Phase 4: Experiment 3 - Multi-Pass (MP) Strategy
# ------------------------------------------------------------------------------
# Multi-Pass mode performs iterative algorithmic passes with deep compaction.
# Budgeted up to 5 patterns to maximize fault coverage and detect corner faults.
create_logic_tests -testmode FULLSCAN -experiment MP -maxpatterns 5
report_fault_statistics -testmode FULLSCAN -experiment MP

# ------------------------------------------------------------------------------
# Phase 5: Termination
# ------------------------------------------------------------------------------
exit
