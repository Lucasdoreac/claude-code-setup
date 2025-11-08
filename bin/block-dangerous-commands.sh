#!/bin/bash
# Bloqueia comandos bash perigosos antes de Claude executar

# Lê o comando do JSON que Claude passa via stdin
COMMAND=$(jq -r '.tool_input.command // ""' 2>/dev/null)

# Se não conseguiu pegar comando, deixar passar (seguro)
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Lista de padrões perigosos (regex)
DANGEROUS_PATTERNS=(
  "rm -rf /"                    # Delete root
  "rm -rf /\*"                  # Delete root com wildcard
  "rm -rf \$HOME"               # Delete home
  "rm -rf ~"                    # Delete home
  "chmod 777"                   # Permissões totalmente abertas
  "chmod -R 777"                # Permissões abertas recursivas
  "mkfs"                        # Format disk
  "dd if=/dev/zero"             # Wipe disk
  ":(){ :|:& };:"               # Fork bomb
  "> /dev/sda"                  # Write to disk directly
  "mv .* /dev/null"             # Move tudo para null
  "wget.*\|.*bash"              # Download e executar script
  "curl.*\|.*bash"              # Download e executar script
  "curl.*\|.*sh"                # Download e executar script
  "shutdown"                    # Desligar sistema
  "reboot"                      # Reiniciar sistema
  "init 0"                      # Halt sistema
  "poweroff"                    # Desligar
)

# Checar se comando contém algum padrão perigoso
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "❌ BLOCKED: Dangerous command pattern detected: $pattern" >&2
    echo "" >&2
    echo "Command was: $COMMAND" >&2
    echo "" >&2
    echo "If you really need this command, run it manually in your terminal." >&2
    exit 2  # Exit code 2 = block tool execution
  fi
done

# Comando é seguro
exit 0
