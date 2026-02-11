#!/usr/bin/env bash
set -euo pipefail

# Example: Debug hook for inspecting Claude Code hook context.
# This script is provided as a development/debugging aid to help you see
# what environment variables and stdin data are passed to hooks.
# It is NOT intended for production use.

# Output environment variables
echo "==== Environment Variables ====" > /tmp/hook-debug.log
env | sort >> /tmp/hook-debug.log

# Output stdin
echo "==== Standard Input ====" >> /tmp/hook-debug.log
cat >> /tmp/hook-debug.log

echo "Debug log written to /tmp/hook-debug.log"