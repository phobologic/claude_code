#!/usr/bin/env bash
set -euo pipefail

# Output environment variables
echo "==== Environment Variables ====" > /tmp/hook-debug.log
env | sort >> /tmp/hook-debug.log

# Output stdin
echo "==== Standard Input ====" >> /tmp/hook-debug.log
cat >> /tmp/hook-debug.log

echo "Debug log written to /tmp/hook-debug.log"