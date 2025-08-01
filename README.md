# protheus-linux-docker
Implantação do ERP TOTVS Protheus com Linux e Docker

Este projeto oferece um ambiente de desenvolvimento robusto e replicável para o ERP TOTVS Protheus. Utilizando Linux como sistema operacional hospedeiro e Docker para a conteinerização, a solução simplifica a complexa instalação nativa, permitindo que desenvolvedores foquem no trabalho com o sistema.

A arquitetura do projeto é baseada em uma pilha tecnológica que isola os principais serviços em contêineres: o AppServer, o DBAccess Server e o banco de dados PostgreSQL. Essa abordagem garante a portabilidade e a estabilidade do ambiente, facilitando a replicação em diferentes máquinas sem conflitos de dependência.

O projeto se destaca por solucionar desafios críticos de infraestrutura, como o ajuste de limites do sistema operacional hospedeiro, a sincronia na inicialização dos serviços e o gerenciamento seguro das credenciais de acesso ao banco de dados. O resultado é um ambiente de desenvolvimento previsível, consistente e de fácil manutenção, ideal para equipes que buscam eficiência e controle.

