Fase 2 — Protheus no Docker (Containers)
Visão Geral
Esta fase avança a partir da instalação no host local (Fase 1) para a virtualização completa do ambiente Protheus usando Docker. O objetivo é containerizar cada serviço (AppServer, DBAccess, PostgreSQL, License Server) para criar um ambiente isolado, portátil e facilmente replicável. O foco aqui é entender como a arquitetura do Protheus se adapta ao paradigma de containers, orquestrando-a com Dockerfile e docker-compose.

Vantagens da Abordagem Docker
A escolha de usar Docker para o ambiente Protheus traz uma série de benefícios que superam a abordagem de máquinas virtuais (VMs) tradicionais. A seguir, detalhamos os principais motivos para adotar essa estratégia:

Leveza e Eficiência: Diferente de uma VM, que simula um sistema operacional completo, um container Docker compartilha o kernel do sistema operacional do host. Isso significa que os containers são muito mais leves e consomem menos recursos (RAM, CPU), permitindo que você execute mais serviços no mesmo hardware. Para um ambiente como o Protheus, com múltiplos serviços rodando simultaneamente, essa eficiência é crucial.

Portabilidade e Consistência: Um dos maiores desafios de qualquer aplicação é garantir que ela funcione da mesma forma em diferentes ambientes. Com o Docker, a imagem do container empacota tudo que a aplicação precisa para rodar (código, bibliotecas, configurações). Isso garante que o ambiente de desenvolvimento, teste e produção seja idêntico, eliminando o clássico problema "na minha máquina funciona".

Isolamento: Cada container é um ambiente isolado. Isso significa que as dependências de um serviço (como o AppServer) não entram em conflito com as de outro (como o DBAccess), mesmo que estejam no mesmo host. Esse isolamento aumenta a segurança e a estabilidade, já que uma falha em um container não afeta os demais.

Gerenciamento Simplificado: Ferramentas como o docker-compose.yml simplificam a orquestração de múltiplos containers. Com um único arquivo, você define todos os serviços, suas interações e volumes. Isso torna a inicialização, parada e atualização do ambiente um processo simples e repetível, algo muito mais complexo de se fazer manualmente com VMs.

Em resumo, a containerização não é apenas uma forma diferente de virtualização, mas uma evolução que oferece mais agilidade, consistência e controle sobre o ambiente, o que é ideal para gerenciar uma aplicação robusta como o Protheus.

Pré-requisitos
Antes de iniciar esta fase, você deve ter:

O ambiente Linux Fedora do Passo 1 da Fase 1 preparado.

Acesso aos mesmos binários da build 2410 - Onça Preta utilizados na Fase 1.

Passo 1: Instalação e Configuração do Docker
O primeiro passo é instalar o Docker Engine e o Docker Compose. O Docker Compose será crucial para gerenciar múltiplos containers de uma só vez.

Instalação do Docker Engine e Docker Compose:

Atualize os pacotes existentes
:$ sudo dnf update -y

Instale o Docker Engine
:$ sudo dnf install -y moby-engine

Instale o Docker Compose, que é o orquestrador para múltiplos containers
:$ sudo dnf install -y docker-compose

Habilitar e Iniciar o Serviço do Docker:
O Docker deve ser configurado para iniciar automaticamente com o sistema.

Habilita o serviço do Docker para iniciar no boot
:$ sudo systemctl enable docker

Inicia o serviço do Docker
:$ sudo systemctl start docker

Adicionar o Usuário ao Grupo docker:
Para executar comandos do Docker sem a necessidade de sudo, adicione o seu usuário ao grupo docker. Você precisará sair e fazer login novamente para que a mudança tenha efeito.

Adiciona o usuário atual ao grupo 'docker'
:$ sudo usermod -aG docker $USER

Passo 2: Estrutura de Diretórios para o Projeto
Uma boa organização é essencial para gerenciar projetos Docker. A seguinte estrutura de diretórios é recomendada para manter os serviços e as configurações separados e claros.

/mnt/docker/totvs/
├── .env                    #Arquivo de variáveis de ambiente
├── docker-compose.yml      #Orquestrador dos containers
├── appserver/
│   ├── Dockerfile            #Instruções para construir a imagem do AppServer
│   ├── app.sh                #Script de inicialização do AppServer
│   ├── appserver.ini         #Arquivo de configuração do AppServer
│   └── appserver_src/        #Binários do AppServer aqui
├── ctreeserver/
│   ├── Dockerfile            #Instruções para construir a imagem do CTreeServer
│   └── ctreeserver_src/      #Binários do CTreeServer aqui
├── dbaccess/
│   ├── Dockerfile            #Instruções para construir a imagem do DBAccess
│   ├── app.sh                #Script de inicialização do DBAccess
│   ├── dbaccess.ini          #Arquivo de configuração do DBAccess
│   └── dbaccess_src/         #Binários do DBAccess aqui
├── postgres_init_scripts/
│   └── init-protheus-db.sql  #Script SQL para inicialização do banco de dados
└── totvslicense/
    ├── Dockerfile            #Instruções para construir a imagem do License Server
    ├── app.sh                #Script de inicialização do License Server
    └── totvslicense_src/     #Binários do License Server aqui

Passo 3: Criação dos Arquivos para o AppServer
Os arquivos necessários para configurar o container do AppServer estão disponíveis no seu repositório do GitHub. Você pode acessá-los aqui: https://github.com/efbtecnologia/protheus-linux-docker/tree/main/totvs.

Arquivo <appserver/appserver.ini>: Define as configurações do AppServer e a conexão com a base de dados na rede do Docker.

Arquivo <appserver/app.sh>: Um script simples para iniciar o AppServer dentro do container.

Arquivo <appserver/Dockerfile>: O "receituário" para construir a imagem do AppServer. Ele contém as instruções para instalar as dependências, copiar arquivos e configurar o ambiente de forma automática.

Passo 4: Criação dos Arquivos para o DBAccess
Os arquivos para o container do DBAccess também estão disponíveis no seu repositório no GitHub.

Arquivo <dbaccess/dbaccess.ini>: Contém as configurações básicas para o DBAccess.

Arquivo <dbaccess/app.sh>: O script de inicialização do DBAccess.

Arquivo <dbaccess/Dockerfile>: O "receituário" para construir a imagem do DBAccess, com as dependências e configurações necessárias.

Passo 5: Criação dos Arquivos para o CTreeServer
O CTreeServer usa o seu padrão de inicialização e não requer arquivos de configuração adicionais. As instruções para criar a imagem do container estão no seu repositório do GitHub.

Arquivo <ctreeserver/Dockerfile>: As instruções para criar a imagem do CTreeServer, incluindo a instalação de dependências e a cópia dos binários.

Passo 6: Criação do docker-compose.yml
O arquivo docker-compose.yml centraliza a orquestração de todos os containers. Ele define a rede interna (protheus_net) e mapeia cada serviço (postgres, dbaccess, ctreeserver, appserver, totvslicense) para que eles possam se comunicar e ser gerenciados de forma simples.

Você pode encontrar o conteúdo completo do arquivo no seu repositório, no link principal: https://github.com/efbtecnologia/protheus-linux-docker/tree/main/totvs.

Passo 7: Compilando e Executando os Containers
Com os Dockerfiles e o docker-compose.yml prontos, a compilação e a execução do ambiente se tornam um único e simples comando.

Navegue até o diretório raiz do seu projeto
:$ cd /mnt/docker/totvs/

Constrói as imagens e inicia todos os serviços em segundo plano (-d)
:$ docker-compose up --build -d

Para verificar o status dos containers em execução
:$ docker-compose ps

Para parar todos os serviços
:$ docker-compose down

Passo 8: Aviso Importante
É fundamental ressaltar que as instalações devem ser realizadas conforme a orientação oficial da TOTVS. Nossa intenção com este guia é fornecer informações sobre possíveis "destravamentos" e soluções para problemas comuns encontrados durante o processo, mas podem haver outros desafios específicos em diferentes ambientes. Este documento serve como um complemento e não substitui a documentação oficial.