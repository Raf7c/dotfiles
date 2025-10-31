#!/bin/sh
# ==========================================
# install/lib/utils.sh
# Utility functions for installation scripts
# ==========================================

# Print functions
print_success() { echo "✅ $1"; }
print_error() { echo "❌ $1" >&2; }
print_warning() { echo "⚠️  $1"; }
print_info() { echo "💡 $1"; }
print_step() { echo "▶️  $1"; }

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    arch) echo "arch" ;;
                    ubuntu|debian) echo "$ID" ;;
                    *) echo "linux" ;;
                esac
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if OS is supported
check_os_support() {
    local os=$(detect_os)
    case "$os" in
        macos|arch)
            print_success "Supported system: $os"
            echo "OS=$os"
            return 0
            ;;
        *)
            print_error "Unsupported system: $os"
            print_info "Supported systems: macOS, Arch Linux"
            return 1
            ;;
    esac
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Run a step with error handling
run_step() {
    local step_name="$1"
    local script_path="$2"
    local critical="${3:-optional}"
    
    print_step "$step_name"
    
    # Execute script directly to respect its shebang
    if "$script_path"; then
        print_success "$step_name completed"
        return 0
    else
        local exit_code=$?
        print_error "$step_name failed (exit code: $exit_code)"
        
        if [ "$critical" = "critical" ]; then
            print_warning "Critical step failed, aborting..."
            exit 1
        else
            print_warning "Non-critical step, continuing..."
            return 1
        fi
    fi
}

# Calculate and format duration
format_duration() {
    local start_time="$1"
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    echo "${minutes}m ${seconds}s"
}

# Setup logging to file and terminal
setup_logging() {
    log_file="$1"
    # Create or clear log file
    : > "$log_file"
    # Note: stdout/stderr will be redirected by run_step function
}

# Check for required commands
check_requirements() {
    echo "🔍 Checking requirements..."
    local missing=0
    
    for cmd in "$@"; do
        if command_exists "$cmd"; then
            print_success "$cmd: $(command -v "$cmd")"
        else
            print_error "Required command not found: $cmd"
            missing=1
        fi
    done
    
    if [ "$missing" -eq 1 ]; then
        echo ""
        print_info "To install missing tools on macOS:"
        echo "   xcode-select --install"
        return 1
    fi
    
    print_success "All requirements met"
    echo ""
    return 0
}

# Run a step only if a command exists
run_if_exists() {
    local tool="$1"
    local description="$2"
    local script_path="$3"
    local critical="${4:-optional}"
    
    if command_exists "$tool"; then
        run_step "$description" "$script_path" "$critical"
    else
        print_info "$tool not found, skipping $description"
    fi
}

# Run a step only if a command exists AND a file exists
run_if_exists_and_file() {
    local tool="$1"
    local file_path="$2"
    local description="$3"
    local script_path="$4"
    local critical="${5:-optional}"
    
    if command_exists "$tool" && [ -f "$file_path" ]; then
        run_step "$description" "$script_path" "$critical"
    else
        if ! command_exists "$tool"; then
            print_info "$tool not found, skipping $description"
        elif [ ! -f "$file_path" ]; then
            print_info "$file_path not found, skipping $description"
        fi
    fi
}

# Generic update function for tools
update_tool() {
    local tool="$1"
    local emoji="$2"
    local description="$3"
    shift 3
    local update_cmd="$@"
    
    if command_exists "$tool"; then
        echo "$emoji Updating $description..."
        if eval "$update_cmd"; then
            print_success "$description updated successfully"
        else
            print_warning "$description update failed"
        fi
    else
        print_warning "$tool not found, skipping $description"
    fi
    echo ""
}