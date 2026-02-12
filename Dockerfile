FROM n8nio/n8n:latest

USER root

# Atualizar sistema e instalar dependências
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    build-base \
    gcc \
    musl-dev \
    libffi-dev \
    libreoffice \
    openjdk11-jre \
    fontconfig \
    ttf-dejavu \
    ttf-liberation \
    && rm -rf /var/cache/apk/*

# Criar symlink para python (algumas bibliotecas esperam 'python')
RUN ln -sf python3 /usr/bin/python

# Copiar arquivo de dependências
COPY requirements.txt /tmp/requirements.txt

# Instalar bibliotecas Python
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements.txt

# Voltar ao usuário n8n
USER node

# Definir variáveis de ambiente
ENV PYTHON_PATH=/usr/bin/python3
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

EXPOSE 5678
CMD ["n8n", "start"]