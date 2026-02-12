# Usar Ubuntu como base e instalar n8n manualmente
FROM ubuntu:22.04

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instalar n8n
RUN npm install -g n8n

# Copiar requirements
COPY requirements.txt /tmp/requirements.txt

# Instalar bibliotecas Python
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Criar usuário n8n
RUN useradd -m -s /bin/bash n8n
USER n8n
WORKDIR /home/n8n

# Variáveis de ambiente
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV PYTHON_PATH=/usr/bin/python3

EXPOSE 5678
CMD ["n8n", "start"]
