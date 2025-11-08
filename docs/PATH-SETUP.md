# PATH Setup - Guia Completo

## 📋 Configuração Automática de PATH

**Data:** 2025-11-08 (Atualizado)
**Status:** ✅ Completamente configurado e organizado

---

## 🎯 O Que Foi Feito

Reorganizamos completamente o `~/.zprofile` e `~/.zshrc` para garantir que **TUDO** que você instalar vá automaticamente para o PATH.

### IMPORTANTE: Mudança de Arquivo
PATH agora está configurado em `~/.zprofile` (não mais em `.zshrc`), porque:
- `.zprofile` roda ANTES do `.zshrc` em login shells
- Garante que PATH esteja correto desde o início
- Evita conflitos com outros arquivos que modificam PATH

### Antes ❌
- 10 linhas `export PATH` espalhadas entre `.zshrc` e `.zprofile`
- Ordem errada (system Ruby sobrescrevia Homebrew Ruby 3.4)
- Duplicações (ex: `$HOME/bin` aparecia 3 vezes)
- Python Framework interferindo com user packages
- Desorganizado e difícil de manter

### Depois ✅
- PATH consolidado em `.zprofile` (arquivo correto)
- Ordem em REVERSO para respeitar prioridade de prepending
- Ruby 3.4 Homebrew com prioridade sobre system Ruby 2.6
- Documentado e testado

---

## 📦 PATH Configurado (em ordem de prioridade)

| # | Diretório | O Que É | Auto-atualiza? |
|---|-----------|---------|----------------|
| 1 | `~/bin` | Seus scripts personalizados | ✅ Sim |
| 2 | `/opt/homebrew/bin` | Homebrew (principais) | ✅ Sim |
| 3 | `~/.nvm/.../bin` | Node.js via NVM | ✅ Sim (NVM) |
| 4 | `~/Library/Python/3.13/bin` | Python user packages | ✅ Sim |
| 5 | `/opt/homebrew/opt/ruby/bin` | Ruby 3.4 (Homebrew) | ✅ Sim |
| 6 | `/opt/homebrew/lib/ruby/gems/.../bin` | Ruby gems | ✅ Sim |
| 7 | `/opt/homebrew/opt/php@8.3/bin` | PHP 8.3 | ✅ Sim |
| 8 | `~/.composer/vendor/bin` | Composer global | ✅ Sim |
| 9 | `~/.cargo/bin` | Rust/Cargo (se instalar) | ✅ Sim |
| 10 | Android SDK | Android platform-tools | ✅ Sim |
| 11 | Cursor IDE | Editor de código | ✅ Sim |

---

## 🤖 Como Funciona a Auto-atualização

### Quando Claude Instala Algo

**NPM Global:**
```bash
npm install -g firebase-tools
```
- ✅ Vai para: `~/.nvm/versions/node/v22.20.0/bin/firebase`
- ✅ Já está no PATH automaticamente!

**Python/pip:**
```bash
pip3 install --user poetry
```
- ✅ Vai para: `~/Library/Python/3.13/bin/poetry`
- ✅ Já está no PATH automaticamente!

**Ruby gems:**
```bash
gem install bundler
```
- ✅ Vai para: `/opt/homebrew/lib/ruby/gems/3.4.0/bin/bundler`
- ✅ Já está no PATH automaticamente!

**Homebrew:**
```bash
brew install jq
```
- ✅ Vai para: `/opt/homebrew/bin/jq`
- ✅ Já está no PATH automaticamente!

**Composer:**
```bash
composer global require laravel/installer
```
- ✅ Vai para: `~/.composer/vendor/bin/laravel`
- ✅ Já está no PATH automaticamente!

**Scripts Personalizados:**
```bash
# Basta colocar em ~/bin/
echo '#!/bin/bash\necho "Hello"' > ~/bin/meu-script
chmod +x ~/bin/meu-script
```
- ✅ Já funciona: `meu-script`

---

## 🔧 Gerenciadores de Versão

### NVM (Node.js)
```bash
nvm install 20      # Instala Node 20
nvm use 20          # Muda para Node 20
# PATH atualizado automaticamente!
```

### pyenv (Python) - Se você usar
```bash
pyenv install 3.12
pyenv global 3.12
# PATH atualizado automaticamente!
```

---

## 📂 Estrutura Recomendada

```
~/
├── bin/                    # Seus scripts (prioridade máxima)
├── .composer/vendor/bin/   # Ferramentas PHP globais
├── .cargo/bin/             # Ferramentas Rust
├── .nvm/                   # Node.js versions
│   └── versions/node/v22.20.0/bin/
└── Library/
    └── Python/3.13/bin/    # Python user packages
```

---

## ✅ Verificação

Execute no terminal:
```bash
echo $PATH | tr ':' '\n' | head -10
```

Deve aparecer **exatamente** na ordem:
1. `/Users/lucascardoso/bin` ← User scripts (MÁXIMA PRIORIDADE)
2. `/opt/homebrew/bin` ← Homebrew core
3. `/opt/homebrew/sbin` ← Homebrew system
4. `~/Library/Python/3.13/bin` ← Python user packages
5. `/Library/Frameworks/Python.framework/.../bin` ← Python Framework
6. `/opt/homebrew/opt/ruby/bin` ← **Homebrew Ruby 3.4** (NÃO system 2.6)
7. `/opt/homebrew/lib/ruby/gems/3.4.0/bin` ← Ruby gems
8. `/opt/homebrew/opt/php@8.3/bin` ← PHP 8.3
9. `~/.composer/vendor/bin` ← Composer global
10. ... (resto)

**Verificação de versões:**
```bash
which ruby && ruby --version   # Deve mostrar Homebrew Ruby 3.4.7
which php && php --version     # Deve mostrar PHP 8.3
which gem                       # Deve mostrar Homebrew gem
```

---

## 🐛 Troubleshooting

### Comando não encontrado após instalar?

1. **Recarregue o shell (opção 1 - rápida):**
   ```bash
   source ~/.zprofile
   ```

   **Ou recarregue tudo (opção 2 - completa):**
   ```bash
   exec zsh -l
   ```

2. **Verifique se foi instalado:**
   ```bash
   # NPM
   npm list -g --depth=0 | grep <pacote>

   # Python
   pip3 list | grep <pacote>

   # Ruby
   gem list | grep <pacote>

   # Homebrew
   brew list | grep <pacote>
   ```

3. **Procure o executável:**
   ```bash
   find /opt/homebrew /Users/lucascardoso/.nvm ~/.composer -name "<comando>" 2>/dev/null
   ```

4. **Se ainda não funcionar:**
   - Verifique se o PATH tem o diretório: `echo $PATH | grep <diretório>`
   - Verifique se `.zprofile` está correto: `cat ~/.zprofile | grep PATH`
   - Verifique se `.zshrc` não está sobrescrevendo: `cat ~/.zshrc | grep "export PATH"`
   - Reinicie o terminal completamente (abre nova janela/aba)

---

## 📝 Backups

Backups automáticos criados:
```
~/.zshrc.backup-20251108-120733
~/.zprofile.backup-<data>
```

Para restaurar:
```bash
# Restaurar .zprofile (PATH configuration)
cp ~/.zprofile.backup-<data> ~/.zprofile
source ~/.zprofile

# Restaurar .zshrc (shell features)
cp ~/.zshrc.backup-<data> ~/.zshrc
source ~/.zshrc
```

### Arquivos de Configuração

- **~/.zprofile:** PATH e environment variables (EDIT THIS for PATH changes)
- **~/.zshrc:** Oh-my-zsh, plugins, aliases, interactive features
- **~/.profile:** Legacy bash config (mantido para compatibilidade)
- **~/.bash_profile:** Legacy bash config (mantido para compatibilidade)

---

## 🎯 Garantia

✅ **Tudo que Claude instalar via:**
- `npm install -g`
- `pip3 install --user`
- `gem install`
- `brew install`
- `composer global require`
- Scripts em `~/bin/`

**Vai AUTOMATICAMENTE para o PATH!**

Não precisa fazer NADA manual! 🎉
