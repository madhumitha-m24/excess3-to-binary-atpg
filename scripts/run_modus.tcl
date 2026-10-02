# ==============================================================================
# File: run_modus.tcl
# Tool: Cadence Modus DFT Software
# Project: 23ECE336 VLSI Testing and Testability
# Topic: Topic 18 - Excess-3 to Binary Converter
# Description: Automated Cadence Modus script for model creation, fault modeling,
#              ATPG pattern generation, fault statistics reporting, hard fault
#              extraction, target coverage capping, and vector export.
# ==============================================================================

# ------------------------------------------------------------------------------
# Step 1: Design Import and Structural Model Building
# ------------------------------------------------------------------------------
# Ingest the structural gate-level Verilog netlist into the Modus internal database.
build_model -designsource rtl/excess3_to_binary.v

# ------------------------------------------------------------------------------
# Step 2: Test Mode Configuration and Design Rule Checking (DRC)
# ------------------------------------------------------------------------------
# Build the test mode configuration representing full-scan / combinational access.
build_testmode -testmode FULLSCAN

# Verify testability structures and execute scan/combinational DRC checks.
verify_test_structures -testmode FULLSCAN

# ------------------------------------------------------------------------------
# Step 3: Fault Model Construction
# ------------------------------------------------------------------------------
# Construct the single stuck-at fault model (collapsed fault list).
build_faultmodel

# ------------------------------------------------------------------------------
# Step 4: Primary ATPG Experiment (FULL - High Effort)
# ------------------------------------------------------------------------------
# Run high-effort deterministic ATPG aiming for maximal fault coverage.
create_logic_tests -testmode FULLSCAN -experiment FULL -effort high

# Report complete fault statistics for the FULL experiment.
report_fault_statistics -testmode FULLSCAN -experiment FULL

# Extract hard-to-test, untested, aborted, and redundant faults into a logfile.
report_faults -testmode FULLSCAN -experiment FULL -faultstatus "untested aborted redundant" -logfile faults_hard.log

# ------------------------------------------------------------------------------
# Step 5: Capped Coverage Experiment (C70 - Max Coverage 70%)
# ------------------------------------------------------------------------------
# Execute logic test generation capped at a 70.0% fault coverage threshold.
create_logic_tests -testmode FULLSCAN -experiment C70 -maxcoverage 70.0

# Report fault statistics for the C70 experiment.
report_fault_statistics -testmode FULLSCAN -experiment C70

# ------------------------------------------------------------------------------
# Step 6: Test Vector Export
# ------------------------------------------------------------------------------
# Export generated ATPG vectors for the FULL experiment in Verilog testbench format.
write_vectors -testmode FULLSCAN -inexperiment FULL -language verilog

# Export generated ATPG vectors for the FULL experiment in IEEE 1450 STIL format.
write_vectors -testmode FULLSCAN -inexperiment FULL -language stil

# ------------------------------------------------------------------------------
# Step 7: Termination
# ------------------------------------------------------------------------------
exit
