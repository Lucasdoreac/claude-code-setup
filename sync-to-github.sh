#!/bin/bash
# Script para sincronizar mudanças locais com GitHub
# Uso: ./sync-to-github.sh "mensagem do commit"

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Verificar se está no diretório correto
if [ ! -d ".git" ]; then
    echo "❌ Não estou no diretório do repositório!"
    echo "Execute: cd /tmp/claude-code-setup"
    exit 1
fi

# Verificar se há mudanças
if ! git diff --quiet || ! git diff --staged --quiet; then
    log "Mudanças detectadas!"
else
    warning "Nenhuma mudança para sincronizar"
    exit 0
fi

# Mensagem do commit
if [ -z "$1" ]; then
    COMMIT_MSG="Sync: Update configurations $(date +%Y-%m-%d)"
else
    COMMIT_MSG="$1"
fi

# Mostrar status
log "Status atual:"
git status --short

echo ""
read -p "Continuar com sync? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warning "Sync cancelado"
    exit 0
fi

# Add all changes
log "Adicionando mudanças..."
git add .

# Commit
log "Criando commit..."
git commit -m "$COMMIT_MSG"
success "Commit criado: $COMMIT_MSG"

# Pull para evitar conflitos
log "Sincronizando com remoto..."
git pull --rebase origin main || {
    warning "Conflito detectado! Resolva manualmente e execute:"
    echo "  git rebase --continue"
    echo "  git push origin main"
    exit 1
}

# Push
log "Enviando para GitHub..."
git push origin main
success "Sync completo! ✨"

# Mostrar último commit
echo ""
log "Último commit:"
git log -1 --oneline

# Mostrar link do repo
REPO_URL=$(git remote get-url origin | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
echo ""
success "Veja no GitHub: $REPO_URL"
