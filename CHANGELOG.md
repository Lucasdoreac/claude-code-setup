# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-08

### Added
- ✨ Initial release of Claude Code Setup
- 📦 PATH configuration optimized for macOS
- 🔧 126 Claude Code permissions
- 🤖 MCP servers: context7 (docs), memory (knowledge graph)
- 🔒 Automated security updates (daily at 2 AM)
- 📝 Complete documentation (README, guides)
- 🚀 One-line installation script
- 🔄 Auto-sync script for GitHub
- 🎯 GitHub Actions workflows (test, sync, docs)
- 📋 Issue and PR templates
- 🤝 CONTRIBUTING guide
- 📚 Git guide for beginners
- 🔐 Dependabot configuration

### Features
- Zero PATH duplications
- Ruby Homebrew 3.4+ support (replaces system Ruby 2.6)
- Auto-installation for npm, pip, gem, composer
- Backup creation before changes
- Validation of JSON configs
- Cross-machine sync capability

### Documentation
- PATH-SETUP.md - Complete PATH guide
- PATH-FIX-SUMMARY.md - Fixes summary
- PATH-CLEANUP-COMPLETE.md - Final verification
- GIT-GUIDE-SIMPLES.md - Git for beginners
- GITHUB-SETUP-REPO.md - Repository setup guide

---

## [1.2.0] - 2025-11-08

### Added
- 🔐 **Deny rules** for secret protection (.env, *.key, *.pem, SSH keys)
- 📁 **Project settings structure** (settings.json for team sharing)
- 🎯 **100% compliance** with Anthropic official best practices

### Changed
- ♻️ Moved `CLAUDE_CODE_ENABLE_TELEMETRY` from .zshrc to settings.json (official recommendation)
- 📝 Updated zshrc-snippet to reference settings.json for Claude env vars
- 🔒 Enhanced security with comprehensive deny rules

### Documentation
- 📊 Added SCORECARD-REVISED.md - Corrected compliance analysis
- 📚 Added OFFICIAL-BEST-PRACTICES.md - Full Anthropic docs reference
- 🔍 Added COMPARISON-OFFICIAL-VS-OURS.md - Gap analysis

### Security
- 🛡️ Secrets now completely invisible to Claude Code
- 🔐 Protected: .env, *.key, *.pem, SSH keys, AWS credentials, database configs
- ✅ Follows Anthropic's security recommendations

---

## [Unreleased]

### Planned
- [ ] Support for Linux (Ubuntu, Debian)
- [ ] Docker container for testing
- [ ] Web dashboard for configuration
- [ ] Auto-update checker
- [ ] More MCP servers (optional)
- [ ] Integration tests
- [ ] Video tutorial

---

## How to Update

```bash
cd ~/claude-code-setup
git pull
./install.sh --update
```

Or use the one-liner:
```bash
curl -fsSL https://raw.githubusercontent.com/Lucasdoreac/claude-code-setup/main/install.sh | bash
```
