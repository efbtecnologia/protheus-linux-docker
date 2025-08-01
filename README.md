# Protheus/TOTVS Moderno em Docker, Fedora, Rocky Linux e CI/CD
Ambiente de laboratório local, modular, para profissionais que buscam domínio real sobre a infraestrutura do Protheus/TOTVS com Linux, Docker, Rocky Linux e DevOps.
Cada fase é independente — utilize onde e como fizer sentido para sua realidade profissional.

🚩 Visão Geral

Este projeto foi desenhado para quem:

Quer rodar Protheus/TOTVS no Fedora puro (quase ninguém faz isso!);
Busca um ambiente Dockerizado flexível, para implantar, testar ou escalar rapidamente;
Precisa simular produção realista em Rocky Linux (padrão de mercado);
Deseja ou está estudando DevOps/CI/CD para Protheus (automatizando deploys e rotinas técnicas).
Cada fase é um microprojeto, com repositório próprio e documentação detalhada.
Você pode usar apenas uma fase, todas, ou seguir na ordem que desejar.

🧩 Fases do Projeto

Fase 1 — Protheus no Fedora (Linux Host Local)

Para quem quer aprender onde tudo começa: Protheus/TOTVS rodando nativamente em Linux, sem camada intermediária, enfrentando as questões de dependência, biblioteca, binários e scripts.

Desafios: Configuração de ODBC, variáveis de ambiente, *.sh de serviços, autenticações e otimizações.

Por que tentar? Aprendizado real do core, domínio da infra, base para todo o resto, e até para quem quer performance máxima.

Quando usar: Quando estudar Protheus/TOTVS no mundo Linux puro, montar laboratório, migrar de Windows, ou querer hackear o ambiente ao limite.

📄 Doc: docs/fase1-install-fedora.md

Fase 2 — Protheus/TOTVS em Docker (Multi-Host)

Para quem precisa de agilidade, praticidade, múltiplos ambientes rápidos (dev, test, prod), estudos de versionamento e rollback entre ambientes.

Desafios: Construção de imagem, montagem de volumes e persistências, parametrização, rede entre containers, atualização sem dor de cabeça.
Por que tentar? Criar, pausar e destruir ambientes Protheus em minutos. Testar deploys, simular infra produtiva ou isolar ambientes críticos.
Quando usar:
Seu host pode ser Windows, Mac, Linux, etc.
Ideal para times, POCs, rotinas Dev/Test/QA, laboratórios ou “playground” seguro.
📄 Doc: docs/fase2-docker.md

Fase 3 — Rocky Linux (Simulação de Produção Corporativa)

Para profissionais e empresas que buscam o melhor da estabilidade, compatibilidade de mercado e práticas corporativas.

Desafios: Replicar ambientes REAIS de produção usando Rocky Linux (clones de Red Hat), entender nuances, automatizar infraestrutura, trabalhar com cloud (AWS, Azure, GCP).
Por que tentar?
Rocky Linux está nos grandes clouds.
Traz experiência e habilidades valorizadas por empresas.
Facilita transição para ambientes produtivos.
Quando usar:
Migrando para cloud;
Quer garantir 100% de compatibilidade;
Precisa testar rotas de exposição externas reais (NGINX, NGROK, VPNs).
📄 Doc: docs/fase3-rockylinux.md

Fase 4 — CI/CD (Integração Contínua & Deploy)

Para quem quer subir um nível: automatizar builds, testes, deploys, rollback, integração entre times e entregar valor mais rápido.

Desafios: Entender conceitos de pipelines, GitHub Actions, GitLab CI, integrações de infraestrutura e “segredos” (credentials, variáveis seguras).
Por que tentar?
Gera agilidade, governança, segurança e profissionalismo;
Automatiza entregas e facilita rollback;
Excelente para equipes, consultorias ou DevOps learners.
Quando usar:
Já tem labs prontos;
Quer transformar infraestrutura tradicional em infraestrutura como código;
Busca certificações, vagas técnicas de mercado, ou entregar inovação no cliente.
📄 Doc: docs/fase4-cicd.md

🗂️ Estrutura Sugerida

protheus-lab/
├── docs/
│   ├── fase1-install-fedora.md
│   ├── fase2-docker.md
│   ├── fase3-rockylinux.md
│   └── fase4-cicd.md
├── fedora-protheus/           # Fase 1
├── docker-protheus/           # Fase 2
├── rockylinux-protheus/       # Fase 3
├── cicd-pipelines/            # Fase 4
├── totvslicense_src/          # Não incluso, cada um monta o seu
├── ctreeserver_src/           # Não incluso, cada um monta o seu
├── dbaccess_src/              # Não incluso, cada um monta o seu
├── protheus_src/              # Não incluso, cada um monta o seu
Pastas *_SRC devem ser providenciadas individualmente, conforme licença TOTVS.

📌 Observações Importantes

Cada fase é independente e pode ser estudada ou utilizada separadamente.
A documentação de cada fase traz dicas, exemplos, scripts e explicações detalhadas dos porquês e comos (inclusive os “perrengues” de cada etapa).
Não fornecemos binários, fontes nem qualquer material copyright da TOTVS, apenas estrutura e exemplos.

✍️ Autor
Emanuel Bezerra - EMATECH
www.linkedin.com/in/emanuel-fbezerra

→ Compartilhe, sugira melhorias, envie Pull Request ou entre em contato pelo LinkedIn!
