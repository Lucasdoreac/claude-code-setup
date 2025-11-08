# Contributing to Claude Code Setup

Obrigado por contribuir! 🎉

## 🚀 Como Contribuir (Simples)

### Opção 1: Reportar Problemas
1. Vá em [Issues](https://github.com/Lucasdoreac/claude-code-setup/issues)
2. Clique em "New Issue"
3. Escolha "Bug Report" ou "Feature Request"
4. Preencha o template

### Opção 2: Sugerir Melhorias
1. Abra uma [Discussion](https://github.com/Lucasdoreac/claude-code-setup/discussions)
2. Descreva sua ideia
3. Aguarde feedback

### Opção 3: Fazer Mudanças (Para quem entende de Git)

#### Setup Local
```bash
# 1. Fork o repositório (clique em Fork no GitHub)

# 2. Clone seu fork
gh repo clone SEU-USUARIO/claude-code-setup
cd claude-code-setup

# 3. Adicione o repo original como upstream
git remote add upstream https://github.com/Lucasdoreac/claude-code-setup.git

# 4. Crie uma branch para suas mudanças
git checkout -b minha-feature
```

#### Fazer Mudanças
```bash
# 1. Edite os arquivos
vim zprofile  # ou qualquer arquivo

# 2. Teste localmente
./install.sh --path-only  # teste sua mudança

# 3. Commit suas mudanças
git add .
git commit -m "feat: descrição da mudança"

# 4. Push para seu fork
git push origin minha-feature

# 5. Crie Pull Request no GitHub
gh pr create --title "Título do PR" --body "Descrição"
```

## 📝 Diretrizes

### Commits
Use prefixos claros:
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Apenas documentação
- `style:` Formatação, espaços
- `refactor:` Refatoração de código
- `test:` Adicionar testes
- `chore:` Manutenção

### Exemplos:
```
feat: adicionar suporte para Python 3.12
fix: corrigir PATH duplicado no .zshrc
docs: atualizar README com exemplos
```

### Testes
Antes de enviar PR:
```bash
# Testar syntax dos scripts
bash -n install.sh
bash -n bin/security-update

# Validar JSON
jq empty claude-config/*.json

# Testar instalação (opcional)
./install.sh --path-only
```

## 🎯 O Que Aceitamos

✅ **SIM:**
- Bug fixes
- Melhorias de documentação
- Suporte para novas versões de ferramentas
- Otimizações de performance
- Melhorias de segurança
- Novos MCP servers (se úteis para maioria)

❌ **NÃO:**
- Mudanças breaking sem discussão prévia
- Código não testado
- Dependências desnecessárias
- Configurações muito específicas/pessoais

## 🔍 Processo de Review

1. **Automated checks**: GitHub Actions vão testar automaticamente
2. **Manual review**: Mantenedores vão revisar o código
3. **Feedback**: Você pode precisar fazer ajustes
4. **Merge**: Se aprovado, será merged!

## 💡 Precisa de Ajuda?

- 📖 Leia a [documentação completa](docs/)
- 💬 Pergunte nas [Discussions](https://github.com/Lucasdoreac/claude-code-setup/discussions)
- 🐛 Reporte bugs via [Issues](https://github.com/Lucasdoreac/claude-code-setup/issues)

## 📊 Mantenedores

- [@Lucasdoreac](https://github.com/Lucasdoreac) - Maintainer

## 🙏 Reconhecimento

Todos os contribuidores serão adicionados ao README!
