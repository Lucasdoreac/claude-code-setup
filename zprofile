# ============================================
# PATH CONFIGURATION (Login Shell)
# ============================================
# This file runs BEFORE .zshrc for login shells
# Build PATH in REVERSE priority order (last export = highest priority)

# 11. Cursor IDE (lowest priority)
if [ -d "/Applications/Cursor.app" ]; then
  export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"
fi

# 10. Android SDK
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi

# 9. LM Studio CLI
if [ -d "$HOME/.lmstudio/bin" ]; then
  export PATH="$HOME/.lmstudio/bin:$PATH"
fi

# 8. .NET Core SDK tools
if [ -d "$HOME/.dotnet/tools" ]; then
  export PATH="$HOME/.dotnet/tools:$PATH"
fi

# 7. Rust/Cargo (if installed)
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# 6. Composer global packages
if [ -d "$HOME/.composer/vendor/bin" ]; then
  export PATH="$HOME/.composer/vendor/bin:$PATH"
fi

# 5. PHP (Homebrew PHP 8.3)
if [ -d "/opt/homebrew/opt/php@8.3" ]; then
  export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
  export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
fi

# 4. Ruby (Homebrew Ruby, NOT system Ruby)
if [ -d "/opt/homebrew/opt/ruby" ]; then
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

  # Find Ruby version dynamically
  if [ -d "/opt/homebrew/lib/ruby/gems" ]; then
    RUBY_VERSION=$(ls /opt/homebrew/lib/ruby/gems | tail -1)
    export PATH="/opt/homebrew/lib/ruby/gems/$RUBY_VERSION/bin:$PATH"
  fi
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

# 3. Python
# Python Framework (if installed by Python.org installer)
if [ -d "/Library/Frameworks/Python.framework/Versions/3.13" ]; then
  export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
fi
# Python user packages (higher priority)
if [ -d "$HOME/Library/Python/3.13/bin" ]; then
  export PATH="$HOME/Library/Python/3.13/bin:$PATH"
fi

# 2. Homebrew (core system) - IMPORTANT: must come BEFORE user bin
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 1. User binaries (HIGHEST PRIORITY - must be last)
export PATH="$HOME/bin:$PATH"
