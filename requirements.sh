#!/bin/bash

# SubShade Requirements Installation Script
# This script installs all necessary tools to run SubShade

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect package manager
detect_package_manager() {
    if command_exists apt-get; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists brew; then
        echo "brew"
    elif command_exists choco; then
        echo "choco"
    elif command_exists scoop; then
        echo "scoop"
    elif [[ "$OSTYPE" == "msys" || "$MSYSTEM" == "MINGW64" || "$MSYSTEM" == "MINGW32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install Go
install_go() {
    local pkg_manager=$1
    
    print_info "Installing Go programming language..."
    
    case $pkg_manager in
        "apt")
            sudo apt-get update
            sudo apt-get install -y golang-go
            ;;
        "yum")
            sudo yum install -y golang
            ;;
        "dnf")
            sudo dnf install -y golang
            ;;
        "pacman")
            sudo pacman -S --noconfirm go
            ;;
        "brew")
            brew install go
            ;;
        "choco")
            choco install golang -y
            ;;
        "scoop")
            scoop install go
            ;;
        "windows")
            print_warning "Detected Git Bash/MSYS environment on Windows"
            print_info "For Windows users, please choose one of these options:"
            echo
            echo "Option 1 - Download Go installer:"
            echo "  1. Visit: https://golang.org/dl/"
            echo "  2. Download the Windows installer (.msi file)"
            echo "  3. Run the installer and follow the setup wizard"
            echo "  4. Restart Git Bash after installation"
            echo
            echo "Option 2 - Use Chocolatey (if installed):"
            echo "  choco install golang"
            echo
            echo "Option 3 - Use Scoop (if installed):"
            echo "  scoop install go"
            echo
            read -p "Have you installed Go using one of the above methods? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_error "Please install Go first, then run this script again"
                return 1
            fi
            ;;
        *)
            print_error "Unsupported package manager. Please install Go manually from https://golang.org/dl/"
            return 1
            ;;
    esac
    
    # Set up Go environment if not already set
    if [[ -z "$GOPATH" ]]; then
        export GOPATH=$HOME/go
        export PATH=$PATH:$GOPATH/bin
        
        # Add to shell profile
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
        
        print_info "Added Go environment variables to ~/.bashrc"
        print_warning "Please run 'source ~/.bashrc' or restart your terminal after installation"
    fi
}

# Function to install Go tools
install_go_tools() {
    print_info "Installing assetfinder..."
    if go install github.com/tomnomnom/assetfinder@latest; then
        print_success "assetfinder installed successfully"
    else
        print_error "Failed to install assetfinder"
        return 1
    fi
    
    print_info "Installing httprobe..."
    if go install github.com/tomnomnom/httprobe@latest; then
        print_success "httprobe installed successfully"
    else
        print_error "Failed to install httprobe"
        return 1
    fi
}

# Function to verify installations
verify_installation() {
    print_info "Verifying installations..."
    
    local all_good=true
    
    if command_exists go; then
        print_success "Go is installed: $(go version)"
    else
        print_error "Go is not installed or not in PATH"
        all_good=false
    fi
    
    if command_exists assetfinder; then
        print_success "assetfinder is installed"
    else
        print_error "assetfinder is not installed or not in PATH"
        all_good=false
    fi
    
    if command_exists httprobe; then
        print_success "httprobe is installed"
    else
        print_error "httprobe is not installed or not in PATH"
        all_good=false
    fi
    
    if $all_good; then
        print_success "All tools are installed and ready to use!"
        return 0
    else
        print_error "Some tools are missing. Please check the installation."
        return 1
    fi
}

# Main installation function
main() {
    echo -e "${CYAN}========================================${RESET}"
    echo -e "${CYAN}  SubShade Requirements Installation    ${RESET}"
    echo -e "${CYAN}========================================${RESET}"
    echo
    
    # Check if running as root when needed
    local pkg_manager=$(detect_package_manager)
    if [[ "$pkg_manager" != "brew" && $EUID -ne 0 && "$pkg_manager" != "unknown" ]]; then
        print_warning "This script may need root privileges for system package installation"
        print_info "You may be prompted for your password"
    fi
    
    print_info "Detected package manager: $pkg_manager"
    echo
    
    # Check what's already installed
    print_info "Checking existing installations..."
    
    if command_exists go; then
        print_success "Go is already installed: $(go version)"
    else
        print_info "Go not found, will install"
        install_go "$pkg_manager" || exit 1
    fi
    
    if command_exists assetfinder; then
        print_success "assetfinder is already installed"
    else
        print_info "assetfinder not found, will install"
    fi
    
    if command_exists httprobe; then
        print_success "httprobe is already installed"
    else
        print_info "httprobe not found, will install"
    fi
    
    echo
    
    # Install Go tools
    if ! command_exists assetfinder || ! command_exists httprobe; then
        print_info "Installing Go tools..."
        install_go_tools || exit 1
    fi
    
    echo
    
    # Verify everything is working
    verify_installation
    
    echo
    print_success "Installation complete!"
    print_info "You can now run SubShade with: ./ss.sh <domain>"
    
    if [[ -n "$GOPATH" ]] && [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
        echo
        print_warning "Don't forget to run: source ~/.bashrc"
        print_warning "Or restart your terminal to apply Go environment changes"
    fi
}

# Run main function
main "$@" 