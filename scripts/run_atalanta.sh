#!/usr/bin/env bash
# ==============================================================================
# File: run_atalanta.sh
# Project: 23ECE336 VLSI Testing and Testability
# Topic: Topic 18 - Excess-3 to Binary Converter
# Description: Automated execution script for Atalanta ATPG tool using the
#              ISCAS-85 benchmark format netlist.
# ==============================================================================

set -o pipefail

BENCH_FILE="bench/excess3_to_binary.bench"
LOG_FILE="atalanta_report.log"

echo "================================================================================"
echo " 23ECE336 VLSI Testing and Testability - Atalanta ATPG Execution"
echo " Topic 18: 4-Bit Excess-3 to Binary Converter"
echo "================================================================================"

# Verify benchmark netlist file existence
if [ ! -f "$BENCH_FILE" ]; then
    echo "[ERROR] Benchmark file not found: $BENCH_FILE"
    echo "Please ensure the script is run from the project root directory (vlsi-tt/)."
    exit 1
fi

echo "[INFO] Target Benchmark Netlist: $BENCH_FILE"
echo "[INFO] Target Log Output File   : $LOG_FILE"

# Check if atalanta executable is installed in PATH
if command -v atalanta >/dev/null 2>&1; then
    ATALANTA_CMD="atalanta"
elif [ -x "./atalanta" ]; then
    ATALANTA_CMD="./atalanta"
elif [ -x "/usr/local/bin/atalanta" ]; then
    ATALANTA_CMD="/usr/local/bin/atalanta"
else
    echo "[WARNING] 'atalanta' command not found in PATH."
    echo "[INFO] Running check in fallback mode and logging simulated ATPG execution commands."
    ATALANTA_CMD=""
fi

if [ -n "$ATALANTA_CMD" ]; then
    echo "[INFO] Executing: $ATALANTA_CMD $BENCH_FILE"
    "$ATALANTA_CMD" "$BENCH_FILE" 2>&1 | tee "$LOG_FILE"
    EXIT_CODE=$?
    echo "================================================================================"
    if [ $EXIT_CODE -eq 0 ]; then
        echo "[STATUS] Atalanta ATPG execution completed successfully."
        echo "[STATUS] Detailed report generated at: $LOG_FILE"
    else
        echo "[ERROR] Atalanta ATPG returned error code $EXIT_CODE."
    fi
    echo "================================================================================"
    exit $EXIT_CODE
else
    echo "[INFO] Recording planned execution command to $LOG_FILE"
    {
        echo "================================================================================"
        echo "Atalanta ATPG Execution Log (Planned Invocation)"
        echo "Target Netlist: $BENCH_FILE"
        echo "Command       : atalanta $BENCH_FILE"
        echo "================================================================================"
        echo "Error: atalanta executable was not found on the local environment PATH."
        echo "To execute on host or lab server:"
        echo "  1. Install Atalanta or add its binary directory to PATH."
        echo "  2. Run: atalanta bench/excess3_to_binary.bench"
    } > "$LOG_FILE"

    echo "[STATUS] Shell runner ready. Once atalanta binary is in PATH, execute ./scripts/run_atalanta.sh."
    exit 0
fi
