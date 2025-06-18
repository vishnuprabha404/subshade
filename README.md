# SubShade - Subdomain Enumeration Tool

SubShade is a bash script for automated subdomain discovery and validation. It finds subdomains for a given domain and checks which ones are actively responding to HTTP requests.

## Features

- 🔍 **Subdomain Discovery**: Uses multiple techniques to find subdomains
- ✅ **Live Subdomain Detection**: Validates which subdomains are actively responding
- 🧹 **Duplicate Removal**: Automatically sorts and removes duplicate entries
- 📊 **Progress Tracking**: Shows real-time progress during execution
- 📁 **Clean Output**: Saves results to an organized text file

## Prerequisites

Before running SubShade, you need to install the following tools:

### Required Tools List
- **assetfinder** - Subdomain discovery tool
- **httprobe** - HTTP/HTTPS probe for checking live subdomains
- **Go** - Programming language (required for installing the above tools)

### Tool Installation Details

#### 1. assetfinder
A tool for finding subdomains using various passive sources.

**Installation:**
```bash
# Using Go (recommended)
go install github.com/tomnomnom/assetfinder@latest

# Alternative: Download binary from releases
# Visit: https://github.com/tomnomnom/assetfinder/releases
```

#### 2. httprobe
A tool for probing URLs to check if they're alive.

**Installation:**
```bash
# Using Go (recommended)
go install github.com/tomnomnom/httprobe@latest

# Alternative: Download binary from releases
# Visit: https://github.com/tomnomnom/httprobe/releases
```

### System Requirements

- **Operating System**: Linux/macOS/WSL/Windows (Git Bash)
- **Shell**: Bash 4.0 or higher
- **Go**: Version 1.19+ (for installing tools)

### Built-in Tools (Usually Available)
The following tools are typically pre-installed on most Unix-like systems:
- `sort` - For sorting and removing duplicates
- `cat` - For reading files
- `wc` - For counting lines
- `mkdir` - For creating directories
- `rm` - For removing files
- `echo` - For displaying output

## Installation

### Option 1: Automatic Installation (Recommended)

1. **Clone or download the script:**
   ```bash
   # If using git
   git clone <your-repo-url>
   cd subshade
   
   # Or download main.sh and requirements.sh directly
   ```

2. **Make the scripts executable:**
   ```bash
   chmod +x main.sh requirements.sh
   ```

3. **Run SubShade - it will auto-install missing tools:**
   ```bash
   ./main.sh example.com
   ```
   If tools are missing, SubShade will automatically detect this and offer to install them for you!

### Option 2: Manual Installation

1. **Install requirements manually:**
   ```bash
   ./requirements.sh
   ```

2. **Or verify dependencies are installed:**
   ```bash
   # Check if tools are available
   which assetfinder
   which httprobe
   ```

## Usage

### Basic Usage
```bash
./main.sh <domain>
```

### Examples
```bash
# Find subdomains for example.com
./main.sh example.com

# Find subdomains for a specific organization
./main.sh tesla.com
```

### Output
The script will:
1. Display progress information during execution
2. Create a file named `<domain>-subdomains.txt` containing all live subdomains
3. Show statistics about discovered subdomains

Example output:
```
   _____ __  ______  _____ __  _____    ____  ______
  / ___// / / / __ )/ ___// / / /   |  / __ \/ ____/
  \__ \/ / / / __  |\__ \/ /_/ / /| | / / / / __/   
 ___/ / /_/ / /_/ /___/ / __  / ___ |/ /_/ / /___   
/____/\____/_____//____/_/ /_/_/  |_/_____/_____/   
                                                    

═══════════════════════════════════════════════════════════
            Subdomain Enumeration & Discovery Tool
═══════════════════════════════════════════════════════════
 Welcome user | Date: 2024-01-15 10:30:45

 Initializing ...

 Gathering subdomains of example.com

Total number of subdomains found : 25

Checking for active subdomains, this might take a while ...

SUBSHADE SUCCESSFULLY COMPLETED !

Total number of active subdomains after sorting is : 12

Check 'example.com-subdomains.txt' for the list of active subdomains
```

## Troubleshooting

### Common Issues

1. **"assetfinder: command not found"**
   - Install assetfinder using the instructions above
   - Ensure your `$GOPATH/bin` is in your `$PATH`

2. **"httprobe: command not found"**
   - Install httprobe using the instructions above
   - Ensure your `$GOPATH/bin` is in your `$PATH`

3. **"Permission denied"**
   - Make sure the script is executable: `chmod +x main.sh`

4. **No results found**
   - The domain might not have publicly discoverable subdomains
   - Check your internet connection
   - Try with a well-known domain like `tesla.com` or `github.com`

### Setting up Go PATH (if needed)
```bash
# Linux/macOS - Add to your ~/.bashrc or ~/.zshrc
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Windows Git Bash - Add to your ~/.bashrc
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

### Manual Installation for Windows/Git Bash Users

If you're using Git Bash on Windows and the automatic installation fails, follow these steps:

#### Option 1: Download Go Installer (Recommended)
1. **Visit the Go downloads page**: https://golang.org/dl/
2. **Download the Windows installer** (`.msi` file) for your system architecture
3. **Run the installer** and follow the setup wizard
4. **Restart Git Bash** after installation
5. **Verify installation**:
   ```bash
   go version
   ```

#### Option 2: Using Package Managers
If you have Chocolatey or Scoop installed:

**Chocolatey:**
```bash
# Open PowerShell as Administrator
choco install golang -y
```

**Scoop:**
```bash
# In PowerShell or Git Bash
scoop install go
```

#### Manual Tool Installation
After Go is installed, manually install the required tools:
```bash
# Install assetfinder
go install github.com/tomnomnom/assetfinder@latest

# Install httprobe  
go install github.com/tomnomnom/httprobe@latest

# Verify installations
assetfinder --help
httprobe --help
```

#### Common Windows Issues

1. **"go: command not found" after installation**
   - Restart Git Bash completely
   - Check if Go is in your PATH: `echo $PATH`
   - Manually add Go to PATH if needed

2. **Tools not found after installation**
   - Check if `$HOME/go/bin` is in your PATH
   - Add it manually: `export PATH=$PATH:$HOME/go/bin`
   - Add to ~/.bashrc to make it permanent

## Contributing

Feel free to contribute by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## Disclaimer

This tool is for educational and authorized security testing purposes only. Always ensure you have permission to test the target domains. The authors are not responsible for any misuse of this tool. 