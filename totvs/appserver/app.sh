#!/bin/bash

# Declara variavel de ambiente para carga de libs .so
declare -x LD_LIBRARY_PATH="/opt/totvs/protheus/protheus/bin/appserver;"$LD_LIBRARY_PATH

echo "Aguardando 10 segundos para as dependencias iniciarem..."
sleep 10

# ulimits podem ser adicionados ao /etc/security/limits.con (ou equivalente)
# e posteriormente adicionada chamada do pam_limits.so no arquivo/etc/pam.d/common-session
# (realizar este procedimento com cautela pois pode danificar o login na maquina)
ulimit -n 32768
ulimit -s 1024
ulimit -m 6144000
ulimit -v 6144000
/opt/totvs/protheus/protheus/bin/appserver/appsrvlinux
