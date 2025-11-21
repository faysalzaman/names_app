#!/bin/bash

# Script to check ELF alignment for 16KB page size compatibility
# Usage: ./check_elf_alignment.sh path/to/apk

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-apk>"
    exit 1
fi

APK_PATH=$1

if [ ! -f "$APK_PATH" ]; then
    echo "Error: APK file not found at $APK_PATH"
    exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Extracting APK to $TEMP_DIR..."

# Extract APK
unzip -q "$APK_PATH" -d "$TEMP_DIR"

# Find all .so files
SO_FILES=$(find "$TEMP_DIR" -name "*.so")

if [ -z "$SO_FILES" ]; then
    echo "No .so files found in APK"
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Check alignment for each .so file
ALL_ALIGNED=true
echo ""
echo "Checking ELF alignment for 16KB page size..."
echo "=============================================="

for so_file in $SO_FILES; do
    RELATIVE_PATH=${so_file#$TEMP_DIR/}
    
    # Check if readelf is available
    if ! command -v readelf &> /dev/null; then
        echo "Warning: readelf not found. Install binutils to check ELF alignment."
        echo "On macOS: brew install binutils"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    # Get alignment info
    ALIGNMENT=$(readelf -l "$so_file" 2>/dev/null | grep -A1 "LOAD" | grep "Align" | head -1 | awk '{print $NF}')
    
    if [ -z "$ALIGNMENT" ]; then
        # Try alternative method
        ALIGNMENT=$(readelf -l "$so_file" 2>/dev/null | grep "LOAD" | head -1 | awk '{print $NF}')
    fi
    
    # Check if alignment is 16KB (0x4000 or 16384)
    if [ "$ALIGNMENT" = "0x4000" ] || [ "$ALIGNMENT" = "16384" ]; then
        echo "✅ $RELATIVE_PATH - Aligned (16KB)"
    else
        echo "❌ $RELATIVE_PATH - NOT aligned (Current: $ALIGNMENT)"
        ALL_ALIGNED=false
    fi
done

echo ""
echo "=============================================="
if [ "$ALL_ALIGNED" = true ]; then
    echo "✅ All native libraries are 16KB aligned!"
    echo "Your app is ready for Android 15+ devices."
else
    echo "❌ Some libraries are not 16KB aligned."
    echo "Please update your dependencies and NDK version."
fi

# Cleanup
rm -rf "$TEMP_DIR"

exit 0
