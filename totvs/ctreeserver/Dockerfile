# Usa o OpenSUSE Leap 15.6 como imagem base, homologado pela TOTVS
FROM opensuse/leap:15.6

# Define metadados da imagem
LABEL maintainer="Emanuel"
LABEL description="TOTVS Ctree Server com OpenSUSE Leap 15.6"

RUN zypper refresh && zypper install -y libuuid1 && zypper clean --all

# Define o fuso horário dentro do contêiner
ENV TZ=America/Sao_Paulo

# Copia a instalação completa do Ctree Server através do link simbólico
COPY ctreeserver_src /opt/totvs/ctreeserver

# Garante que o script de inicialização startace seja executável
RUN chmod +x /opt/totvs/ctreeserver/faircom/linux.x64.64bit/startace

# O WORKDIR aponta para onde o executável 'startace' está.
WORKDIR /opt/totvs/ctreeserver/faircom/linux.x64.64bit
CMD ["./startace"]

# Porta que o Ctree Server escuta
EXPOSE 7899