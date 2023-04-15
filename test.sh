#!/bin/bash

# Try block
if output=$(echo hello 2>&1); then
    echo "Command succeeded"
    echo "$output"
# Catch block
else
    echo "Command failed"
    echo "$output"
fi