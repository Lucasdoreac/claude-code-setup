#!/bin/bash
# Claude Code Setup - Automated Installer
# Version: 1.0.0

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_SUFFIX="backup-$(date +%Y%m%d-%H%M%S)"
INSTALL_ALL=true
INSTALL_PATH=false
INSTALL_CLAUDE=false
INSTALL_SECURITY=false
UPDATE_MODE=false

# Functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
    exit 1
}

banner() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   Claude Code Setup - Installer       ║"
    echo "║   Production Ready Configuration      ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
}

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This setup is designed for macOS only"
    fi
    success "macOS detected"
}

check_homebrew() {
    if ! command -v brew &> /dev/null; then
        warning "Homebrew not found"
        echo "Install Homebrew? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            success "Homebrew installed"
        else
            error "Homebrew is required. Aborting."
        fi
    else
        success "Homebrew found"
    fi
}

backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        cp "$file" "$file.$BACKUP_SUFFIX"
        success "Backed up: $file → $file.$BACKUP_SUFFIX"
    fi
}

install_path_config() {
    log "Installing PATH configuration..."

    backup_file "$HOME/.zprofile"
    backup_file "$HOME/.zshrc"

    # Install .zprofile
    cp zprofile "$HOME/.zprofile"
    success "Installed: ~/.zprofile"

    # Update .zshrc (append snippet if not present)
    if ! grep -q "LANGUAGE VERSION MANAGERS" "$HOME/.zshrc" 2>/dev/null; then
        cat zshrc-snippet >> "$HOME/.zshrc"
        success "Updated: ~/.zshrc"
    else
        warning "~/.zshrc already configured, skipping"
    fi

    success "PATH configuration installed"
}

install_claude_config() {
    log "Installing Claude Code configuration..."

    # Create .claude directory
    mkdir -p "$HOME/.claude"

    backup_file "$HOME/.claude/settings.local.json"
    backup_file "$HOME/.mcp.json"

    # Install configs
    cp claude-config/settings.local.json "$HOME/.claude/settings.local.json"
    cp claude-config/mcp.json "$HOME/.mcp.json"

    success "Claude Code configuration installed"
}

install_security_updates() {
    log "Installing security updates..."

    # Create bin directory
    mkdir -p "$HOME/bin"
    mkdir -p "$HOME/.update-logs"

    backup_file "$HOME/bin/security-update"

    # Install script
    cp bin/security-update "$HOME/bin/security-update"
    chmod +x "$HOME/bin/security-update"
    success "Installed: ~/bin/security-update"

    # Setup cron job
    if crontab -l 2>/dev/null | grep -q "security-update"; then
        warning "Cron job already exists, skipping"
    else
        (crontab -l 2>/dev/null; echo "0 2 * * * $HOME/bin/security-update >> $HOME/.update-logs/cron-output.log 2>&1") | crontab -
        success "Cron job configured (runs daily at 2 AM)"
    fi
}

install_ruby_homebrew() {
    log "Checking Ruby installation..."

    if brew list ruby &>/dev/null; then
        success "Homebrew Ruby already installed"
    else
        warning "Homebrew Ruby not found"
        echo "Install Homebrew Ruby 3.4+? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            brew install ruby
            success "Homebrew Ruby installed"
        fi
    fi
}

verify_installation() {
    log "Verifying installation..."

    # Reload shell
    source "$HOME/.zprofile" 2>/dev/null || true

    # Check Ruby
    if command -v ruby &>/dev/null; then
        RUBY_PATH=$(which ruby)
        RUBY_VERSION=$(ruby --version | cut -d' ' -f2)

        if [[ "$RUBY_PATH" == *"homebrew"* ]]; then
            success "Ruby: $RUBY_VERSION (Homebrew) ✓"
        else
            warning "Ruby: $RUBY_VERSION (System - should be Homebrew)"
        fi
    fi

    # Check PATH
    if [[ "$PATH" == *"$HOME/bin"* ]]; then
        success "PATH: ~/bin configured ✓"
    else
        warning "PATH: ~/bin not found"
    fi

    # Check security-update
    if [ -x "$HOME/bin/security-update" ]; then
        success "Security updates: configured ✓"
    fi

    # Check Claude Code
    if [ -f "$HOME/.claude/settings.local.json" ]; then
        success "Claude Code: configured ✓"
    fi
}

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --path-only       Install only PATH configuration"
    echo "  --claude-only     Install only Claude Code config"
    echo "  --security-only   Install only security updates"
    echo "  --update          Update existing installation"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Install everything"
    echo "  $0 --path-only        # Install only PATH config"
    echo "  $0 --update           # Update existing installation"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --path-only)
            INSTALL_ALL=false
            INSTALL_PATH=true
            shift
            ;;
        --claude-only)
            INSTALL_ALL=false
            INSTALL_CLAUDE=true
            shift
            ;;
        --security-only)
            INSTALL_ALL=false
            INSTALL_SECURITY=true
            shift
            ;;
        --update)
            UPDATE_MODE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Main installation
banner

check_macos
check_homebrew

if [ "$UPDATE_MODE" = true ]; then
    log "Running in UPDATE mode..."
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_PATH" = true ]; then
    install_path_config
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_CLAUDE" = true ]; then
    install_claude_config
fi

if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_SECURITY" = true ]; then
    install_security_updates
fi

if [ "$INSTALL_ALL" = true ]; then
    install_ruby_homebrew
fi

verify_installation

echo ""
success "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal: exec zsh -l"
echo "  2. Verify Ruby: which ruby && ruby --version"
echo "  3. Check PATH: echo \$PATH | tr ':' '\n' | head -10"
echo "  4. Documentation: ~/.claude/PATH-SETUP.md"
echo ""
