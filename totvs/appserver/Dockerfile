# Usa o OpenSUSE Leap 15.4 como imagem base, homologado pela TOTVS
FROM opensuse/leap:15.6

# Define metadados da imagem
LABEL maintainer="Emanuel"
LABEL description="TOTVS AppServer com OpenSUSE Leap 15.4 (via app.sh)"

RUN zypper refresh && zypper install -y libgcc_s1 libstdc++6 libuuid1 libpq5 && zypper clean --all

# Define o fuso horário dentro do contêiner
ENV TZ=America/Sao_Paulo

# Copia a instalação completa do Protheus através do link simbólico
COPY protheus_src /opt/totvs/protheus

#Copia os arquivos de configuração e script para seus destinos no container
COPY appserver.ini /opt/totvs/protheus/protheus/bin/appserver/appserver.ini
COPY app.sh /opt/totvs/protheus/protheus/bin/appserver/app.sh

# Garante que o script app.sh do AppServer seja executável
RUN chmod +x /opt/totvs/protheus/protheus/bin/appserver/app.sh

# Comando para iniciar o AppServer usando o seu script app.sh
WORKDIR /opt/totvs/protheus/protheus/bin/appserver
CMD ["./app.sh"]

# Portas que o AppServer escuta (para documentação, o mapeamento real é no docker-compose)
EXPOSE 1234
EXPOSE 4321