# Fase 1 — Protheus no Fedora (Linux Host Local)

Visão Geral
Esta fase detalha o processo de instalação e configuração do ERP TOTVS Protheus diretamente em um sistema operacional Linux Fedora. O objetivo é que o profissional entenda o funcionamento do Protheus em seu ambiente nativo, sem camadas de virtualização. O foco aqui é dominar o "core" da infraestrutura: dependências, bibliotecas, binários, scripts de serviços (*.sh), autenticações e otimizações de sistema.

Pré-requisitos
Antes de iniciar esta fase, você deve ter acesso aos binários da build 2410 - Onça Preta do AppServer, DBAccess Server, CTree Server e TOTVS License Server. A TOTVS não fornece o banco de dados, que deve ser providenciado separadamente.

É fundamental que todos os binários sejam compatíveis com a build 2410 - Onça Preta para garantir a estabilidade do ambiente.

# Passo 1: Preparação do Ambiente Host
Atualização do Sistema: Verifique se seu sistema Fedora está completamente atualizado.

:$ sudo nf update -y

Instalação de Dependências: O Protheus, AppServer, DBAccess, etc., precisam de bibliotecas homologadas para as distribuições suportadas pela TOTVS. Consulte a documentação oficial da TOTVS para a lista exata.

Configuração de Limites do Kernel: O limite padrão de arquivos abertos no Linux é baixo para a carga de trabalho de um AppServer. Ajuste o limite para 102400 para garantir a estabilidade.

# Passo 2: Instalação e Configuração do Banco de Dados PostgreSQL
Nesta etapa, vamos instalar e configurar o PostgreSQL, o SGBD que será usado pelo Protheus. A TOTVS não fornece este software, apenas o homologa.

Instalação do PostgreSQL: Instale o PostgreSQL, que será usado pelo Protheus.

:$ sudo dnf install -y postgresql-server postgresql-contrib

Inicialização e Habilitação do Serviço: Inicialize o banco de dados e habilite o serviço para iniciar automaticamente com o sistema.

:$ sudo postgresql-setup --initdb
:$ sudo systemctl enable postgresql
:$ sudo systemctl start postgresql

Criação do Usuário e Banco de Dados protheus_dev: O Protheus precisa de um banco de dados com configurações de codificação e ordenação específicas para funcionar corretamente. O SGBD será criado com um novo usuário, e o banco de dados se chamará protheus_dev.

Codificação (ENCODING 'WIN1252'): É a codificação essencial para a compatibilidade com ambientes Windows legados do Protheus.

Ordenação (LC_COLLATE e LC_CTYPE): C garante uma ordenação baseada em bytes, o que é fundamental para evitar problemas de ordenação com o Protheus. C.UTF-8 é uma opção segura e moderna.

Primeiro, acesse o console do PostgreSQL com o usuário postgres e execute os comandos abaixo para criar o usuário e o banco de dados com a codificação correta:

:$ sudo -u postgres psql

No console do psql, crie o novo usuário e o banco de dados:

CREATE USER protheus WITH PASSWORD '1234';
CREATE DATABASE protheus_dev WITH ENCODING 'WIN1252' LC_COLLATE='C' LC_CTYPE='C' TEMPLATE=template0 OWNER protheus;
\q

Atenção: A senha 1234 é apenas um exemplo didático e deve ser alterada imediatamente para uma senha segura em um ambiente de produção.

# Passo 3: Instalação e Organização dos Serviços Protheus
Obtenção dos Binários: Baixe a build 2410 - Onça Preta e seus respectivos binários diretamente do site da TOTVS, garantindo que a versão seja compatível com o Fedora.

Descompactação: Os arquivos virão em formato .tar.gz. Descompacte-os em suas pastas correspondentes dentro do seu projeto.

Execução do Instalador: Para cada binário (AppServer, DBAccess, etc.), execute o instalador. Alguns instaladores podem ser arquivos .jar que exigem o Java.

Estrutura de Pastas: Organize os binários e serviços em uma estrutura de diretórios lógica. A seguir, apresentamos a nossa estrutura de referência, que foi utilizada com sucesso neste projeto:

/mnt/Acer_HD/docker/totvs/
├── appserver/
├── ctreeserver/
├── dbaccess/
└── totvslicense/

# Passo 4: Scripts de Inicialização
Criação dos Scripts: Crie um script shell (.sh) para iniciar cada serviço. Você pode usar um único arquivo, como app.sh, para iniciar o AppServer, DBAccess e TOTVS License Server. Para o CTree Server, os scripts de inicialização (startace) e parada (stopace) já existem na pasta de instalação, e você deve usá-los diretamente.

Configuração dos Scripts: Configure os scripts de inicialização do AppServer, DBAccess e TOTVS License Server, referenciando os respectivos arquivos .ini e as demais pastas necessárias.

Exemplo de script para o AppServer:
crie o app.sh e cole o conteudo:
#--- APOS AQUI ---

#!/bin/bash

#Declara variavel de ambiente para carga de libs .so
declare -x LD_LIBRARY_PATH="/opt/totvs/protheus/protheus/bin/appserver;"$LD_LIBRARY_PATH

echo "Aguardando 10 segundos para as dependencias iniciarem..."
sleep 10

#ulimits podem ser adicionados ao /etc/security/limits.con (ou equivalente)
#e posteriormente adicionada chamada do pam_limits.so no arquivo/etc/pam.d/common-session
#(realizar este procedimento com cautela pois pode danificar o login na maquina)
ulimit -n 32768
ulimit -s 1024
ulimit -m 6144000
ulimit -v 6144000
/opt/totvs/protheus/protheus/bin/appserver/appsrvlinux

#--- ATE AQUI ---

Nota: Assegure-se de que o caminho no script (/opt/totvs/protheus/protheus/bin/appserver) corresponde exatamente ao local da sua instalação.

Exemplo de script para o DBAccess:

crie o app.sh e cole o conteudo:
#--- APOS AQUI ---

#!/bin/sh

#Define o limite de arquivos abertos (ulimit -n) para o processo do DBAccess.
#Este é um limite importante para a operação de servidores.
ulimit -n 65535

echo "Iniciando DBAccess com limite de arquivos abertos definido..."
echo "Limite de arquivos abertos (ulimit -n): $(ulimit -n)"

#Executa o binário do DBAccess no modo console.
/opt/totvs/dbaccess/multi/dbaccess64 -console

#--- ATE AQUI ---

Nota: Assegure-se de que o caminho no script (/opt/totvs/dbaccess/multi/dbaccess64) corresponde exatamente ao local da sua instalação.

Exemplo de script para o TOTVS License Server (semelhante ao appserver, também deve criar um app.sh):

#!/bin/sh

#Define o limite de arquivos abertos para o processo do License Server.
ulimit -n 65535

echo "Iniciando TOTVS License Server..."

#O executável do License Server é o mesmo do AppServer, mas em sua própria pasta.
/opt/totvs/totvslicense/appsrvlinux


Nota: Assegure-se de que o caminho no script (/opt/totvs/totvslicense/appsrvlinux) corresponde exatamente ao local da sua instalação.

Automação do Serviço: Integre os scripts de inicialização ao systemd para que os serviços iniciem automaticamente quando o Fedora for reiniciado, garantindo que o ambiente esteja sempre operacional.

# Passo 5: Configurações Adicionais de Conectividade
Criação de Link Simbólico para o DBAccess: O DBAccess procura por um driver ODBC com um nome específico (libpsqlodbc.so). Como o arquivo real na sua distribuição pode ter um nome diferente (psqlodbca.so), é necessário criar um link simbólico para que a conectividade funcione corretamente.

Comando: O comando a seguir cria um link simbólico do arquivo real (psqlodbca.so) para o nome que o DBAccess espera (libpsqlodbc.so).

:$ sudo ln -s /usr/lib64/psqlodbca.so /usr/lib64/libpsqlodbc.so

Nota: O caminho /usr/lib64/psqlodbca.so é um exemplo. Para encontrar o caminho e o nome exatos do seu driver, você pode usar o comando find / -name "psqlodbca.so" 2>/dev/null ou find / -name "*psqlodbc*.so" 2>/dev/null.

Configuração do odbc.ini: O arquivo odbc.ini é fundamental para que o DBAccess saiba como se conectar ao banco de dados. Ele contém as informações do Data Source Name (DSN). Este arquivo deve ser criado ou editado na pasta /etc.

Caminho do arquivo: /etc/odbc.ini

Conteúdo do arquivo: Abaixo está um exemplo de configuração para o PostgreSQL. Altere os valores de Servername, Port, Database, Username e Password para as suas configurações. Observe que o Driver agora aponta para o nome da biblioteca canônico que você criou no passo anterior.

[PROTHEUS_POSTGRES]
Driver=/usr/lib64/libpsqlodbc.so
Servername=localhost
Port=5432
Database=protheus_dev
Username=protheus
Password=1234
CommLog=1

Nota: O caminho do Driver (/usr/lib64/libpsqlodbc.so) deve ser o mesmo que você utilizou no comando de link simbólico.

# Passo 6: Criptografia da Senha no DBMonitor
Após a configuração inicial do DBAccess, é fundamental criptografar a senha do banco de dados para que a comunicação com o PostgreSQL funcione corretamente. Mesmo que a senha esteja correta no arquivo odbc.ini, o DBAccess precisa salvá-la em seu próprio formato criptografado.

Acesse o DBMonitor: Inicie o DBAccess e acesse o DBMonitor.

Abra a Configuração: Vá para a tela de configurações do DBAccess, onde você configurou o DSN.

Re-insira a Senha: Re-insira a senha do usuário protheus no campo correspondente.

Salve a Configuração: Clique em "Salvar" ou "Aplicar". O DBMonitor irá criptografar a senha e salvá-la no arquivo de configuração do DBAccess (dbaccess.ini).

Atenção: Se este passo não for realizado, o DBAccess tentará descriptografar a senha não-criptografada no dbaccess.ini e a comunicação com o banco de dados falhará.

# Passo 7: Validação
Após a configuração, a validação é crucial. Verifique o status de cada serviço, use as ferramentas de log para garantir que não há erros, e confirme que o AppServer está acessível e que a conexão com o banco de dados foi estabelecida com sucesso.

# Passo 8: Aviso Importante
É fundamental ressaltar que as instalações devem ser realizadas conforme a orientação oficial da TOTVS. Nossa intenção com este guia é fornecer informações sobre possíveis "destravamentos" e soluções para problemas comuns encontrados durante o processo, mas podem haver outros desafios específicos em diferentes ambientes. Este documento serve como um complemento e não substitui a documentação oficial.