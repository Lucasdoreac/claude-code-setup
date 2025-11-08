# PATH Configuration Fix - Resumo

**Data:** 2025-11-08
**Status:** ✅ RESOLVIDO

---

## 🐛 Problema Identificado

### Ruby usando versão errada
```bash
# ANTES (errado):
which ruby  → /usr/bin/ruby
ruby --version → ruby 2.6.10 (2022, DESATUALIZADO)

# DEPOIS (correto):
which ruby  → /opt/homebrew/opt/ruby/bin/ruby
ruby --version → ruby 3.4.7 (2025-10-08, ATUAL)
```

### Causa Raiz
1. **PATH estava configurado no arquivo errado** (`.zshrc` em vez de `.zprofile`)
2. `.zprofile` roda ANTES do `.zshrc` em login shells
3. `.zprofile` tinha Python Framework prepended, bagunçando ordem
4. Ruby Homebrew estava AUSENTE do PATH inteiramente

### Ordem de Startup do Zsh
```
Login Shell (ex: abrir novo terminal):
1. ~/.zshenv (não existe)
2. ~/.zprofile ← PATH DEVE SER CONFIGURADO AQUI
3. ~/.zshrc    ← Features interativas (plugins, aliases)
4. ~/.zlogin   (não usado)
```

---

## ✅ Solução Implementada

### 1. Moveu PATH para `.zprofile`
- Todo PATH configuration foi movido de `.zshrc` para `.zprofile`
- Garante que PATH é configurado ANTES de qualquer outra coisa

### 2. Ordem Reversa de Prioridade
Como `export PATH="/new:$PATH"` prepende, a ordem é:
```bash
# ÚLTIMO export = PRIMEIRA posição no PATH final
# (construir em ordem REVERSA da prioridade desejada)

11. Cursor IDE (menor prioridade)
10. Android SDK
9. LM Studio
8. .NET Tools
7. Rust/Cargo
6. Composer
5. PHP 8.3
4. Ruby 3.4 + gems
3. Python (user packages + Framework)
2. Homebrew
1. ~/bin (MAIOR PRIORIDADE - last export)
```

### 3. Ruby Homebrew Configurado
```bash
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
```

---

## 📊 Resultado Final

### PATH Verificado (ordem correta)
```
1. /Users/lucascardoso/bin
2. /opt/homebrew/bin
3. /opt/homebrew/sbin
4. ~/Library/Python/3.13/bin
5. /Library/Frameworks/Python.framework/.../bin
6. /opt/homebrew/opt/ruby/bin          ← Homebrew Ruby 3.4
7. /opt/homebrew/lib/ruby/gems/3.4.0/bin
8. /opt/homebrew/opt/php@8.3/bin
9. ~/.composer/vendor/bin
10. ~/.dotnet/tools
... (resto)
```

### Comandos Verificados
```bash
✅ which ruby  → /opt/homebrew/opt/ruby/bin/ruby (3.4.7)
✅ which gem   → /opt/homebrew/opt/ruby/bin/gem
✅ which php   → /opt/homebrew/bin/php (8.3.27)
✅ which node  → /opt/homebrew/bin/node (via NVM)
✅ which python3 → /opt/homebrew/bin/python3
```

---

## 🔧 Scripts Atualizados

### 1. `~/bin/security-update` (bug fix)
**Linha 68:** Fixed integer expression error
```bash
# ANTES (errado):
MACOS_UPDATES=$(softwareupdate --list 2>&1 | grep -c "recommended" || echo "0")
if [ "$MACOS_UPDATES" -gt 0 ]; then

# DEPOIS (correto):
MACOS_UPDATES=$(softwareupdate --list 2>&1 | grep "recommended" | wc -l | xargs)
if [ "${MACOS_UPDATES:-0}" -gt 0 ]; then
```

**Resultado:** Script agora roda sem erros, atualiza Ruby gems corretamente usando Homebrew Ruby

---

## 📝 Documentação Atualizada

### Files Modified:
- `~/.zprofile` - Completamente reescrito com PATH correto
- `~/.claude/PATH-SETUP.md` - Atualizado com .zprofile info
- `~/bin/security-update` - Bug fix linha 68

### Backups Created:
- `~/.zprofile.backup-<timestamp>`
- `~/.zshrc.backup-20251108-120733`

---

## 🎯 Garantia

Agora **TUDO** que Claude instalar via:
- ✅ `npm install -g` → vai para NVM bin (já no PATH)
- ✅ `pip3 install --user` → vai para `~/Library/Python/3.13/bin` (já no PATH)
- ✅ `gem install` → vai para `/opt/homebrew/lib/ruby/gems/3.4.0/bin` (já no PATH)
- ✅ `brew install` → vai para `/opt/homebrew/bin` (já no PATH)
- ✅ `composer global require` → vai para `~/.composer/vendor/bin` (já no PATH)
- ✅ Scripts em `~/bin/` → maior prioridade no PATH

**NENHUMA ação manual necessária!** 🎉

---

## 🧪 Para Testar em Novo Terminal

```bash
# 1. Abrir novo terminal (ou executar):
exec zsh -l

# 2. Verificar PATH:
echo $PATH | tr ':' '\n' | head -10

# 3. Verificar Ruby:
which ruby && ruby --version
# Deve mostrar: /opt/homebrew/opt/ruby/bin/ruby
#              ruby 3.4.7

# 4. Verificar gems:
gem list | head -5
# Deve mostrar gems do Homebrew Ruby 3.4

# 5. Instalar teste (opcional):
gem install bundler
which bundler
# Deve mostrar: /opt/homebrew/lib/ruby/gems/3.4.0/bin/bundler
```

---

## ⚠️ Importante

Se em algum momento o PATH voltar a estar errado:
1. Verifique se `.zprofile` não foi modificado: `cat ~/.zprofile | grep PATH`
2. Verifique se outro arquivo não está sobrescrevendo: `cat ~/.zshrc | grep "export PATH"`
3. Recarregue: `source ~/.zprofile`
4. Se necessário, restaure backup: `cp ~/.zprofile.backup-<data> ~/.zprofile`

---

## 📚 Referências

- **Documentação:** `~/.claude/PATH-SETUP.md`
- **Config principal:** `~/.zprofile`
- **Backups:** `~/.zprofile.backup-*`
- **Security updates:** `~/bin/security-update` (roda daily às 2h AM)
