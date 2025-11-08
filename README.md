# Claude Code Setup - Production Ready

Configuração completa e otimizada para Claude Code no macOS, com PATH organizado, MCP servers, security updates automáticos e zero leftovers.

## 🚀 Features

- ✅ **PATH Otimizado**: Ordem de prioridade correta para todas as linguagens
- ✅ **Ruby Homebrew 3.4+**: Substitui system Ruby 2.6 obsoleto
- ✅ **Auto-instalação**: Tudo que Claude instalar vai automaticamente para o PATH
- ✅ **Security Updates**: Script automatizado roda daily às 2h AM
- ✅ **MCP Servers**: Apenas os essenciais (context7, memory)
- ✅ **126 Permissions**: Desenvolvimento sem bloqueios
- ✅ **Zero Leftovers**: Sem duplicações ou conflitos

## 📋 O Que Está Incluído

### Arquivos de Configuração
```
.zprofile          → PATH configuration (login shells)
.zshrc             → Oh-my-zsh, plugins, aliases
settings.local.json → Claude Code permissions
.mcp.json          → MCP servers configuration
bin/security-update → Automated security updates
```

### PATH Priority
```
1. ~/bin                              (user scripts)
2. /opt/homebrew/bin                  (Homebrew core)
3. ~/Library/Python/3.13/bin          (Python user packages)
4. /opt/homebrew/opt/ruby/bin         (Ruby 3.4 Homebrew)
5. /opt/homebrew/opt/php@8.3/bin      (PHP 8.3)
6. ~/.composer/vendor/bin             (Composer global)
7. ~/.cargo/bin                       (Rust)
8. IDE tools (Cursor, etc.)
```

## 🛠️ Instalação Automática

### Método 1: Script Rápido (Recomendado)
```bash
curl -fsSL https://raw.githubusercontent.com/Lucasdoreac/claude-code-setup/main/install.sh | bash
```

### Método 2: Clone Manual
```bash
# 1. Clone o repositório
git clone https://github.com/Lucasdoreac/claude-code-setup.git
cd claude-code-setup

# 2. Execute o instalador
chmod +x install.sh
./install.sh
```

### Método 3: Instalação Personalizada
```bash
# Clone e escolha o que instalar
git clone https://github.com/Lucasdoreac/claude-code-setup.git
cd claude-code-setup

# Instalar apenas PATH configuration
./install.sh --path-only

# Instalar apenas Claude Code config
./install.sh --claude-only

# Instalar apenas security updates
./install.sh --security-only

# Ver todas as opções
./install.sh --help
```

## 📦 Pré-requisitos

### Obrigatórios
- macOS (testado em macOS Sonoma 14.6+)
- Homebrew instalado
- Zsh (default no macOS)

### Recomendados
- Claude Code CLI instalado
- Node.js (via NVM)
- Ruby 3.4+ (via Homebrew, script instala automaticamente)
- PHP 8.3+ (via Homebrew)

### Instalação dos Pré-requisitos
```bash
# Homebrew (se não tiver)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ruby 3.4
brew install ruby

# PHP 8.3
brew install php@8.3

# Node.js (via NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 22
```

## 🎯 O Que o Instalador Faz

### 1. Backup Automático
- Cria backup de todos os arquivos existentes
- Formato: `arquivo.backup-YYYYMMDD-HHMMSS`
- Localização: mesmo diretório dos arquivos originais

### 2. PATH Configuration (`.zprofile`)
- Remove duplicações e conflitos
- Ordem reversa para prepending correto
- Ruby Homebrew com prioridade sobre system Ruby
- Auto-configuração para npm, pip, gem, composer

### 3. Shell Features (`.zshrc`)
- Remove export PATH duplicados
- Mantém: NVM, pyenv, aliases, plugins
- Oh-my-zsh compatibility

### 4. Claude Code Config
- `~/.claude/settings.local.json` com 126 permissions
- `~/.mcp.json` com context7 e memory
- Skills directory setup

### 5. Security Updates
- `~/bin/security-update` executable
- Cron job configurado para 2h AM daily
- Logs em `~/.update-logs/`
- Atualiza: Homebrew, npm, Python, Ruby, macOS

## 📚 Documentação Completa

Após instalação, documentação disponível em:
- `~/.claude/PATH-SETUP.md` - Guia completo do PATH
- `~/.claude/PATH-FIX-SUMMARY.md` - Resumo das correções
- `~/.claude/PATH-CLEANUP-COMPLETE.md` - Verificação final

## ✅ Verificação Pós-Instalação

```bash
# 1. Recarregar shell
exec zsh -l

# 2. Verificar Ruby
which ruby
# Esperado: /opt/homebrew/opt/ruby/bin/ruby
ruby --version
# Esperado: ruby 3.4.x

# 3. Verificar PATH
echo $PATH | tr ':' '\n' | head -10
# Primeira linha deve ser: /Users/seu-usuario/bin

# 4. Verificar Claude Code
claude --version

# 5. Testar security-update
~/bin/security-update
```

## 🔧 Personalização

### Adicionar Novos Paths
Edite `~/.zprofile` (não `.zshrc`!):
```bash
# Adicionar ANTES do "# 1. User binaries"
export PATH="/seu/novo/caminho:$PATH"
```

### Adicionar Aliases
Edite `~/.zshrc`:
```bash
# Adicionar na seção "# ALIASES"
alias meu-comando="seu comando aqui"
```

### Adicionar MCP Servers
Edite `~/.mcp.json`:
```json
{
  "mcpServers": {
    "seu-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@seu/pacote@latest"]
    }
  }
}
```

## 🐛 Troubleshooting

### Ruby ainda mostra versão 2.6
```bash
# Verificar se PATH está correto
echo $PATH | grep homebrew/opt/ruby
# Se não aparecer, recarregue:
source ~/.zprofile
```

### Comando não encontrado após instalar via npm/gem
```bash
# Recarregar PATH
source ~/.zprofile
# ou
exec zsh -l
```

### Security-update não roda automaticamente
```bash
# Verificar cron job
crontab -l | grep security-update

# Re-adicionar se necessário
(crontab -l 2>/dev/null; echo "0 2 * * * $HOME/bin/security-update >> $HOME/.update-logs/cron-output.log 2>&1") | crontab -
```

### Claude Code não reconhece MCP servers
```bash
# Verificar syntax do .mcp.json
cat ~/.mcp.json | jq .
# Se erro, corrigir JSON

# Reiniciar Claude Code
pkill -f "claude"
claude
```

## 🔄 Atualização

Para atualizar este setup:
```bash
cd ~/claude-code-setup
git pull
./install.sh --update
```

## 🗑️ Desinstalação

```bash
cd ~/claude-code-setup
./uninstall.sh
```

Ou manual:
```bash
# Restaurar backups
cp ~/.zprofile.backup-* ~/.zprofile
cp ~/.zshrc.backup-* ~/.zshrc

# Remover cron job
crontab -l | grep -v security-update | crontab -

# Remover scripts
rm ~/bin/security-update
```

## 📊 Estatísticas

- **126 permissions** configuradas para Claude Code
- **13 export PATH** organizados em `.zprofile`
- **0 export PATH** duplicados em `.zshrc`
- **2 MCP servers** essenciais (context7, memory)
- **5 package managers** cobertos (brew, npm, pip, gem, composer)
- **98%+ token reduction** com Progressive Tool Disclosure

## 🤝 Contribuindo

Encontrou um bug ou tem sugestão? Abra uma issue!

## 📝 License

MIT License - Use livremente

## 🙏 Créditos

- [Claude Code](https://claude.com/claude-code) - Anthropic
- [Homebrew](https://brew.sh)
- [Oh My Zsh](https://ohmyz.sh)
- MCP Protocol - Anthropic
