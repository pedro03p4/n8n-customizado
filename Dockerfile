FROM n8nio/n8n:latest

USER root

# Atualizar sistema e instalar dependências (Ubuntu/Debian)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    gcc \
    libffi-dev \
    libreoffice \
    default-jre \
    fontconfig \
    fonts-dejavu \
    fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Criar symlink para python
RUN ln -sf python3 /usr/bin/python

# Atualizar pip
RUN python3 -m pip install --upgrade pip

# Copiar arquivo de dependências
COPY requirements.txt /tmp/requirements.txt

# Instalar bibliotecas Python
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Voltar ao usuário n8n
USER node

# Definir variáveis de ambiente
ENV PYTHON_PATH=/usr/bin/python3
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

EXPOSE 5678
CMD ["n8n", "start"]
