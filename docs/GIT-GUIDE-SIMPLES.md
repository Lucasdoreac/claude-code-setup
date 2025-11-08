# Git - Guia Super Simples

Para quem não entende muito de Git. 🚀

---

## 🎯 Conceitos Básicos (em 1 minuto)

**Git** = Sistema para salvar versões do seu código
**GitHub** = Site onde você guarda essas versões online
**Repository (repo)** = Pasta com seu código
**Commit** = Salvar mudanças com uma mensagem
**Push** = Enviar commits para GitHub
**Pull** = Baixar atualizações do GitHub

---

## 📝 Comandos Essenciais (você só precisa desses!)

### 1. Ver o que mudou
```bash
git status
```
Mostra quais arquivos você modificou.

### 2. Salvar mudanças localmente
```bash
git add .
git commit -m "descrição do que mudou"
```
**Exemplo:**
```bash
git commit -m "Adicionei suporte para PHP 8.4"
```

### 3. Enviar para GitHub
```bash
git push
```
Envia suas mudanças para o GitHub.

### 4. Baixar atualizações
```bash
git pull
```
Baixa mudanças que outras pessoas fizeram.

---

## 🔄 Workflow Diário (Copie e Cole)

```bash
# 1. Ver o que mudou
git status

# 2. Adicionar tudo
git add .

# 3. Salvar com mensagem
git commit -m "Update: sua mensagem aqui"

# 4. Enviar para GitHub
git push
```

**Pronto!** É só isso que você precisa na maioria das vezes.

---

## 🆘 Comandos de Emergência

### Desfazer mudanças que NÃO foram commitadas
```bash
git restore .
```
⚠️ **CUIDADO:** Isso apaga suas mudanças não salvas!

### Ver histórico de commits
```bash
git log --oneline
```
Mostra todos os commits anteriores.

### Voltar para commit anterior
```bash
git log --oneline  # Veja o código do commit
git reset --hard abc123  # Use o código do commit
```
⚠️ **CUIDADO:** Isso apaga commits posteriores!

### "Salvei algo errado, quero desfazer"
```bash
# Se NÃO deu push ainda:
git reset --soft HEAD~1  # Volta 1 commit, mantém mudanças

# Se JÁ deu push:
git revert HEAD  # Cria commit que desfaz o anterior
git push
```

---

## 🎓 Para Este Repositório Específico

### Atualizar setup no seu Mac
```bash
cd /tmp/claude-code-setup

# Baixar atualizações
git pull

# Ver mudanças
git log --oneline -5

# Reinstalar se necessário
./install.sh --update
```

### Enviar suas melhorias
```bash
cd /tmp/claude-code-setup

# Editar arquivos (exemplo)
vim zprofile

# Salvar e enviar
git add .
git commit -m "Melhorei o PATH para Ruby 3.5"
git push
```

### Script Automático (O MAIS FÁCIL!)
```bash
cd /tmp/claude-code-setup

# Use o script que criamos:
./sync-to-github.sh "Minha mensagem de commit"
```

Ele faz tudo automaticamente! ✨

---

## 🔧 Setup Inicial (Só 1 Vez)

### Configurar seu nome
```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

### Configurar GitHub CLI (recomendado)
```bash
gh auth login
```
Depois disso, muita coisa fica mais fácil!

---

## 💡 Dicas Úteis

### Ver diferenças antes de commitar
```bash
git diff
```

### Ver apenas arquivos que mudaram
```bash
git status --short
```

### Commitar apenas arquivos específicos
```bash
git add zprofile
git commit -m "Atualizado apenas zprofile"
```

### Ver quanto você contribuiu
```bash
git log --author="seu-nome" --oneline
```

---

## 🚀 Usando gh CLI (Ainda Mais Fácil!)

Se você instalou GitHub CLI (`gh`):

### Ver repositório
```bash
gh repo view
```

### Criar commit e push
```bash
gh repo sync  # Sincroniza automaticamente
```

### Ver issues
```bash
gh issue list
```

### Ver pull requests
```bash
gh pr list
```

---

## 📊 Fluxo Completo (Com Explicação)

```bash
# PASSO 1: Ver situação atual
git status
# Output: "modified: zprofile"

# PASSO 2: Ver exatamente o que mudou
git diff zprofile
# Mostra linha por linha o que mudou

# PASSO 3: Adicionar mudanças
git add zprofile
# Ou adicionar tudo:
git add .

# PASSO 4: Verificar o que vai ser commitado
git status
# Output: "Changes to be committed: zprofile"

# PASSO 5: Commitar com mensagem
git commit -m "feat: adicionar Ruby 3.5 no PATH"

# PASSO 6: Enviar para GitHub
git push

# PASSO 7: Verificar no GitHub
gh repo view --web
```

---

## ⚡ Atalhos do Repositório

### Atualizar este repo
```bash
# Método 1: Manual
cd /tmp/claude-code-setup
git pull
git add .
git commit -m "Update"
git push

# Método 2: Script automático
cd /tmp/claude-code-setup
./sync-to-github.sh "Update configs"

# Método 3: GitHub Actions (remoto)
# Vai em Actions → Auto-Sync Local Changes → Run workflow
```

---

## 🎯 Cheat Sheet (Cola)

```bash
# Ver mudanças
git status

# Salvar mudanças
git add .
git commit -m "mensagem"
git push

# Baixar atualizações
git pull

# Ver histórico
git log --oneline

# Usar script automático
./sync-to-github.sh "mensagem"
```

**ISSO É TUDO QUE VOCÊ PRECISA!** 🎉

Copie esses comandos e use quando precisar.

---

## 🆘 Problemas Comuns

### "error: failed to push"
```bash
# Alguém fez mudanças antes de você
git pull --rebase
git push
```

### "You have divergent branches"
```bash
# Suas mudanças divergiram do GitHub
git pull --rebase
# Ou se quiser forçar (cuidado!):
git push --force
```

### "Permission denied"
```bash
# Configure autenticação
gh auth login
```

### "Not a git repository"
```bash
# Você não está na pasta certa
cd /tmp/claude-code-setup
```

---

## 📚 Recursos

- **GitHub CLI Docs:** https://cli.github.com/manual/
- **Git Cheat Sheet:** https://education.github.com/git-cheat-sheet-education.pdf
- **Git Book (PT-BR):** https://git-scm.com/book/pt-br/v2

---

## 💬 Precisa de Ajuda?

1. Leia este guia (você está aqui!)
2. Pergunte no ChatGPT: "Como fazer X com git?"
3. Abra uma issue no GitHub
4. Use o script automático `sync-to-github.sh`

**Não tenha medo de errar! Git salva tudo.** ✨
