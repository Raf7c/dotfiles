#!/bin/sh

# Core helpers for dots CLI

detect_os() {
    uname_s=$(uname -s 2>/dev/null || echo "Unknown")
    case "$uname_s" in
        Darwin)
            printf 'macOS'
            ;;
        Linux)
            printf 'Linux'
            ;;
        CYGWIN*|MINGW*|MSYS*)
            printf 'Windows'
            ;;
        *)
            printf 'Unknown'
            ;;
    esac
}

get_os_version() {
    os="$1"
    case "$os" in
        macOS)
            if command -v sw_vers >/dev/null 2>&1; then
                sw_vers -productVersion
            else
                uname -r
            fi
            ;;
        Linux)
            if command -v lsb_release >/dev/null 2>&1; then
                lsb_release -ds 2>/dev/null | tr -d '"'
            elif [ -r /etc/os-release ]; then
                . /etc/os-release
                printf '%s\n' "${PRETTY_NAME:-$NAME}"
            else
                uname -r
            fi
            ;;
        Windows)
            uname -r 2>/dev/null || printf 'Windows\n'
            ;;
        *)
            uname -sr 2>/dev/null || printf 'Version inconnue\n'
            ;;
    esac
}

print_os_info() {
    os="$1"
    log_info "$os détecté"
    version="$(get_os_version "$os")"
    log_info "Version de l'OS : $version"
    printf "Version de l'OS : %s\n" "$version"
}

run_step() {
    description="$1"
    shift

    log_info "Exécution : $description"
    if ! "$@"; then
        log_error "Échec : $description"
        return 1
    fi
    log_success "$description terminée"
    return 0
}

