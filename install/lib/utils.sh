#!/bin/bash
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
    
    if sh "$script_path"; then
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
    local log_file="$1"
    exec > >(tee -a "$log_file")
    exec 2>&1
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

# Verify macOS
check_macos() {
    if [ "$(uname -s)" != "Darwin" ]; then
        print_error "This script must be run on macOS"
        return 1
    fi
    return 0
}

