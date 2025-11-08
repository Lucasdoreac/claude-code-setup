# Como Manter o Setup Sempre Atualizado

Guia para manter seu repositório e setup sempre atualizados. 🔄

---

## 🎯 Objetivo

Você quer que:
1. Seu Mac tenha sempre a configuração mais recente
2. O repositório GitHub reflita suas mudanças locais
3. Outras pessoas vejam suas melhorias
4. Tudo funcione automaticamente

---

## 🔄 Workflow Recomendado

### Cenário 1: Você Fez Mudanças Locais

```bash
# 1. Entre na pasta do setup local
cd /tmp/claude-code-setup

# 2. Copie arquivos atualizados do seu sistema
cp ~/.zprofile zprofile
cp ~/.claude/settings.local.json claude-config/settings.local.json
cp ~/bin/security-update bin/security-update

# 3. Use o script automático
./sync-to-github.sh "Update: descrição das mudanças"
```

**Pronto!** ✨ Mudanças no GitHub.

---

### Cenário 2: Alguém Fez Mudanças no GitHub

```bash
# 1. Baixar atualizações
cd /tmp/claude-code-setup
git pull

# 2. Aplicar no seu Mac
./install.sh --update

# 3. Verificar
source ~/.zprofile
which ruby  # Deve mostrar Homebrew Ruby
```

---

### Cenário 3: Setup em Novo Mac

```bash
# 1. Clone o repo
git clone https://github.com/Lucasdoreac/claude-code-setup.git
cd claude-code-setup

# 2. Instale tudo
./install.sh

# 3. Reload shell
exec zsh -l
```

---

## 🤖 Automação com GitHub Actions

### 1. Auto-Sync (Remoto)

O repositório tem um workflow que pode sincronizar mudanças remotamente:

```bash
# Via gh CLI:
gh workflow run auto-sync.yml -f commit_message="Update configs"

# Ou no GitHub:
# Actions → Auto-Sync Local Changes → Run workflow
```

### 2. Auto-Test

Toda vez que você faz push, GitHub Actions testa:
- ✅ Syntax dos scripts
- ✅ Validação de JSON
- ✅ Permissões dos arquivos

Veja em: https://github.com/Lucasdoreac/claude-code-setup/actions

### 3. Dependabot

Atualiza automaticamente:
- GitHub Actions versions
- Docker images (se adicionar)

---

## 📊 Estratégias de Atualização

### Opção A: Push Manual Frequente (Recomendado)

```bash
# Toda vez que mudar algo:
cd /tmp/claude-code-setup
cp ~/.zprofile zprofile  # Copiar mudanças
./sync-to-github.sh "Update zprofile"
```

**Vantagens:**
- Controle total
- Sabe exatamente o que mudou
- Commits com mensagens descritivas

---

### Opção B: Script de Cron Automático

Crie um script que sincroniza diariamente:

```bash
# Criar: ~/bin/auto-sync-setup
cat > ~/bin/auto-sync-setup << 'EOF'
#!/bin/bash
cd /tmp/claude-code-setup

# Copiar arquivos atuais
cp ~/.zprofile zprofile
cp ~/.claude/settings.local.json claude-config/settings.local.json
cp ~/bin/security-update bin/security-update

# Verificar mudanças
if ! git diff --quiet; then
    git add .
    git commit -m "Auto-sync: $(date +%Y-%m-%d)"
    git push
fi
EOF

chmod +x ~/bin/auto-sync-setup

# Adicionar ao cron (roda todo dia às 18h)
(crontab -l 2>/dev/null; echo "0 18 * * * $HOME/bin/auto-sync-setup >> $HOME/.update-logs/auto-sync.log 2>&1") | crontab -
```

**Vantagens:**
- Totalmente automático
- Sempre atualizado
- Zero esforço

**Desvantagens:**
- Commits com mensagens genéricas
- Menos controle

---

### Opção C: Hook Git Pre-Commit

Copia arquivos automaticamente antes de cada commit:

```bash
# Criar hook
cat > /tmp/claude-code-setup/.git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Auto-copy arquivos antes de commit

cp ~/.zprofile zprofile 2>/dev/null || true
cp ~/.claude/settings.local.json claude-config/settings.local.json 2>/dev/null || true
cp ~/bin/security-update bin/security-update 2>/dev/null || true

git add zprofile claude-config/settings.local.json bin/security-update
EOF

chmod +x /tmp/claude-code-setup/.git/hooks/pre-commit
```

**Vantagens:**
- Sempre sincronizado ao commitar
- Não esquece de copiar

---

## 🎯 Workflow Completo (Recomendação)

```bash
# ==================================
# PASSO 1: Fazer mudanças no seu Mac
# ==================================

# Editar arquivo
vim ~/.zprofile

# Testar
source ~/.zprofile
which ruby  # Verificar

# ==================================
# PASSO 2: Sincronizar com repo
# ==================================

cd /tmp/claude-code-setup

# Copiar versão atualizada
cp ~/.zprofile zprofile

# Ver o que mudou
git diff zprofile

# Commitar e enviar
./sync-to-github.sh "feat: adicionar Ruby 3.5 support"

# ==================================
# PASSO 3: Verificar no GitHub
# ==================================

gh repo view --web
# Ou abrir: https://github.com/Lucasdoreac/claude-code-setup

# ==================================
# PASSO 4: Criar nova release (opcional)
# ==================================

# Se mudança for significativa:
git tag v1.1.0
git push --tags

# GitHub Actions vai criar release automaticamente
```

---

## 📅 Rotina Sugerida

### Diário
- Usar o setup normalmente
- Não precisa sincronizar todo dia

### Semanal
```bash
# Sincronizar mudanças
cd /tmp/claude-code-setup
cp ~/.zprofile zprofile
cp ~/.claude/settings.local.json claude-config/settings.local.json
./sync-to-github.sh "Weekly sync"
```

### Mensal
```bash
# Atualizar tudo
cd /tmp/claude-code-setup
git pull
./install.sh --update

# Atualizar security-update
~/bin/security-update

# Criar release se houve mudanças importantes
git tag v1.X.0
git push --tags
```

---

## 🔍 Monitoramento

### Ver mudanças locais não sincronizadas
```bash
cd /tmp/claude-code-setup

# Comparar com sistema
diff ~/.zprofile zprofile
diff ~/.claude/settings.local.json claude-config/settings.local.json
```

### Ver últimas atualizações no GitHub
```bash
gh repo view --web
# Ou
git log --oneline -10
```

### Ver status de Actions
```bash
gh run list --limit 5
# Ou ver no web:
gh repo view --web
# Actions tab
```

---

## 🐛 Troubleshooting

### "Mudanças não aparecem no GitHub"
```bash
cd /tmp/claude-code-setup
git status  # Ver se commitou
git log -1  # Ver último commit
git push    # Enviar
```

### "Conflito ao fazer git pull"
```bash
# Salvar mudanças locais
git stash

# Baixar atualizações
git pull

# Aplicar mudanças locais de volta
git stash pop
```

### "Esqueci de copiar arquivo antes de commitar"
```bash
# Copiar arquivo
cp ~/.zprofile zprofile

# Adicionar ao último commit
git add zprofile
git commit --amend --no-edit
git push --force
```

---

## 📊 Ferramentas Úteis

### VS Code com Git
Se usa VS Code:
1. Abra a pasta: `code /tmp/claude-code-setup`
2. Source Control (Ctrl+Shift+G)
3. Ver mudanças visualmente
4. Commit e push com cliques

### GitHub Desktop
Alternativa gráfica ao Git:
```bash
brew install --cask github
```

### Watch Files
Auto-sync quando arquivo muda:
```bash
brew install fswatch

# Watch .zprofile
fswatch -o ~/.zprofile | while read; do
    cd /tmp/claude-code-setup
    cp ~/.zprofile zprofile
    git add zprofile
    git commit -m "Auto: zprofile updated"
    git push
done
```

---

## 🎓 Checklist Semanal

- [ ] Baixar atualizações: `git pull`
- [ ] Copiar arquivos: `cp ~/.zprofile zprofile`
- [ ] Ver mudanças: `git status`
- [ ] Commitar: `./sync-to-github.sh "Weekly update"`
- [ ] Verificar GitHub Actions: `gh run list`
- [ ] Testar security-update: `~/bin/security-update`

---

## 🎉 Resumo

**Mais Simples:**
```bash
./sync-to-github.sh "Update"
```

**Automatizado:**
```bash
# Setup cron job que roda todo dia
~/bin/auto-sync-setup
```

**Manual Completo:**
```bash
cd /tmp/claude-code-setup
cp ~/.zprofile zprofile
git add .
git commit -m "Update"
git push
```

**Escolha o que funciona melhor para você!** ✨
