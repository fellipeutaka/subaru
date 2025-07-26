#!/bin/bash

# Development script for Subaru VS Code Theme
# This script helps with local development and testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is available
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    else
        print_status "Node.js is available ($(node --version))"
    fi
}

# Check if npm is available
check_npm() {
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    else
        print_status "npm is available ($(npm --version))"
    fi
}

# Package the extension
package_extension() {
    print_status "Packaging extension with npx @vscode/vsce..."
    npx @vscode/vsce package
    print_status "Extension packaged successfully!"
}

# Install extension locally
install_local() {
    print_status "Installing extension locally..."
    VSIX_FILE=$(ls *.vsix 2>/dev/null | head -1)
    if [ -z "$VSIX_FILE" ]; then
        print_error "No .vsix file found. Run 'package' command first."
        exit 1
    fi
    code --install-extension "$VSIX_FILE"
    print_status "Extension installed locally!"
}

# Show help
show_help() {
    echo "Subaru VS Code Theme Development Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  package    Package the extension using npx"
    echo "  install    Install the extension locally"
    echo "  test       Package and install locally"
    echo "  check      Check if required tools are available"
    echo "  clean      Remove generated .vsix files"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 test      # Package and install for local testing"
    echo "  $0 package   # Just package the extension"
    echo "  $0 clean     # Clean up .vsix files"
    echo ""
    echo "Notes:"
    echo "  - Uses npx to run @vscode/vsce (no global installation needed)"
    echo "  - Requires Node.js and npm to be installed"
}

# Clean up .vsix files
clean_vsix() {
    print_status "Cleaning up .vsix files..."
    rm -f *.vsix
    print_status "Cleanup completed!"
}

# Check tools
check_tools() {
    print_status "Checking required tools..."
    check_node
    check_npm
    
    # Check if VS Code is available
    if command -v code &> /dev/null; then
        print_status "VS Code CLI is available"
    else
        print_warning "VS Code CLI is not available. Local installation won't work."
    fi
    
    print_status "All required tools are available!"
    print_status "Using npx means no global package installation is needed."
}

# Main script logic
case "$1" in
    "package")
        check_node
        check_npm
        package_extension
        ;;
    "install")
        install_local
        ;;
    "test")
        check_node
        check_npm
        package_extension
        install_local
        ;;
    "check")
        check_tools
        ;;
    "clean")
        clean_vsix
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
