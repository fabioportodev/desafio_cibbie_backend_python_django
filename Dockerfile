FROM python:3.7-slim

# Define os argumentos
ARG PORT
ARG SECRET_KEY
ARG DEBUG


# Atualiza o apt-get
#RUN apt-get update && apt-get -y install python3-pip
#RUN ln /usr/bin/python3 /usr/bin/python && ln /usr/bin/pip3 /usr/bin/pip

# Variáveis de ambiente
ENV PORT=${PORT}
ENV DATABASE_PATH=${PORT}
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Criar diretórios
RUN mkdir /app
RUN mkdir /app/base

# Selecionando o diretório de trabalho
WORKDIR /app

# Copiando requirements.txt
COPY requirements.txt /app/

#Atualizar o pip
RUN pip install --upgrade pip

# Instalar os pacotes listados no requirements.txt apenas se forem originados do site informado
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Cria um usuario
RUN useradd python

# Copiar o conteúdo do diretório atual para o conteiner em /app
COPY --chown=python . /app

# Muda o usuário
USER python

#Porta de exposição
EXPOSE ${PORT}

# Executar o arquivo principal do projeto quando o conteiner for iniciado
CMD python manage.py runserver 0.0.0.0:${PORT}