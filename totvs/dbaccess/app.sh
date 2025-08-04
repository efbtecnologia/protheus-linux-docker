#!/bin/sh

# Define o limite de arquivos abertos (ulimit -n) para o processo do DBAccess.
# Este é um limite importante para a operação de servidores.
ulimit -n 65535

echo "Iniciando DBAccess com limite de arquivos abertos definido..."
echo "Limite de arquivos abertos (ulimit -n): $(ulimit -n)"

# Executa o binário do DBAccess no modo console.
/opt/totvs/dbaccess/multi/dbaccess64 -console