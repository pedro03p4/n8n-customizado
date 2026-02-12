FROM n8nio/n8n:latest

USER root

# Descobrir qual sistema está rodando e instalar Python
RUN if command -v apk >/dev/null 2>&1; then \
        echo "Alpine detectado - usando apk"; \
        apk update && apk add --no-cache python3 py3-pip python3-dev build-base gcc musl-dev libffi-dev; \
    elif command -v apt-get >/dev/null 2>&1; then \
        echo "Ubuntu/Debian detectado - usando apt-get"; \
        apt-get update && apt-get install -y python3 python3-pip python3-dev build-essential gcc libffi-dev; \
    elif command -v yum >/dev/null 2>&1; then \
        echo "CentOS/RHEL detectado - usando yum"; \
        yum update -y && yum install -y python3 python3-pip python3-devel gcc; \
    else \
        echo "Sistema não identificado - tentando instalar pip diretamente"; \
        curl -sS https://bootstrap.pypa.io/get-pip.py | python3 || true; \
    fi

# Verificar se Python está disponível
RUN python3 --version || echo "Python não encontrado"
RUN pip3 --version || echo "Pip não encontrado"

# Criar symlink para python
RUN ln -sf python3 /usr/bin/python || echo "Symlink falhou"

# Copiar requirements
COPY requirements.txt /tmp/requirements.txt

# Instalar bibliotecas Python essenciais (uma por vez para debug)
RUN pip3 install --no-cache-dir python-docx==0.8.11 || echo "Falha: python-docx"
RUN pip3 install --no-cache-dir lxml==4.9.3 || echo "Falha: lxml"
RUN pip3 install --no-cache-dir requests==2.31.0 || echo "Falha: requests"
RUN pip3 install --no-cache-dir jinja2==3.1.2 || echo "Falha: jinja2"

# Voltar ao usuário node
USER node

# Variáveis de ambiente
ENV PYTHON_PATH=/usr/bin/python3
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

EXPOSE 5678
CMD ["n8n", "start"]
