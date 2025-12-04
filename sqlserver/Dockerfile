FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Instala dependências
RUN apt-get update && apt-get install -y curl gnupg apt-transport-https

# Adiciona repositório Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list \
    -o /etc/apt/sources.list.d/msprod.list

# Instala sqlcmd
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev \
    && ln -s /opt/mssql-tools/bin/sqlcmd /usr/local/bin/sqlcmd

# Volta para o usuário do SQL Server
USER mssql
