#!/bin/bash
# Smart formatter que detecta o tipo de arquivo e aplica o formatter correto

FILE="$1"

# Se não passou arquivo, pega do stdin JSON (Claude hook)
if [ -z "$FILE" ]; then
  FILE=$(jq -r '.tool_output.file_path // .tool_input.file_path // .tool_input.new_path // ""' 2>/dev/null)
fi

# Se ainda não tem arquivo, sair
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  exit 0
fi

# Detectar extensão
EXT="${FILE##*.}"

case "$EXT" in
  js|jsx|ts|tsx|json|css|scss|html|md)
    # JavaScript/TypeScript/etc - usar Prettier
    if [ -f "package.json" ]; then
      npx prettier --write "$FILE" 2>/dev/null || true
      # ESLint apenas para JS/TS
      if [[ "$EXT" =~ ^(js|jsx|ts|tsx)$ ]]; then
        npx eslint --fix "$FILE" 2>/dev/null || true
      fi
    fi
    ;;

  php)
    # PHP - usar PHP-CS-Fixer se disponível
    if command -v php-cs-fixer &> /dev/null; then
      php-cs-fixer fix "$FILE" 2>/dev/null || true
    elif [ -f "vendor/bin/php-cs-fixer" ]; then
      ./vendor/bin/php-cs-fixer fix "$FILE" 2>/dev/null || true
    fi
    ;;

  py)
    # Python - usar black se disponível
    if command -v black &> /dev/null; then
      black "$FILE" 2>/dev/null || true
    fi
    ;;

  *)
    # Outros arquivos - nada fazer
    exit 0
    ;;
esac

exit 0
