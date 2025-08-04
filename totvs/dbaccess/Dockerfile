FROM fedora:40 

# Define metadados da imagem
LABEL maintainer="Emanuel"
LABEL description="TOTVS DBAccess com OpenSUSE Leap 15.4"

#RUN FEDORA
RUN dnf update -y && dnf install -y libstdc++ libgcc libuuid libpqxx-devel psqlodbc unixODBC && dnf clean all

# Define o fuso horário dentro do contêiner
ENV TZ=America/Sao_Paulo

# Copia a instalação completa do DBAccess através do link simbólico
COPY dbaccess_src /opt/totvs/dbaccess

# Copia os arquivos de configuração para seus destinos no container
# Garanta que dbaccess.ini e odbc.ini estejam no diretório './dbaccess/' no seu host
COPY dbaccess.ini /opt/totvs/dbaccess/multi/dbaccess.ini
COPY odbc.ini /etc/odbc.ini

# Adiciona o link simbólico para o driver ODBC (crucial para o DBAccess)
RUN ln -sf /usr/lib64/psqlodbc.so /usr/lib64/libpsqlodbc.so

# Garante que o script app.sh do DBAccess e o executável dbaccess64 sejam executáveis
RUN chmod +x /opt/totvs/dbaccess/app.sh && chmod +x /opt/totvs/dbaccess/multi/dbaccess64

# O DBAccess usa o app.sh, que está na pasta /opt/totvs/dbaccess.
# Ele ajusta LD_LIBRARY_PATH e então executa dbaccess64, que está em 'multi'.
# O WORKDIR aponta para onde o app.sh está.
WORKDIR /opt/totvs/dbaccess/
CMD ["./app.sh"]

# Porta que o DBAccess escuta (para documentação, mapeamento real no docker-compose)
EXPOSE 7890