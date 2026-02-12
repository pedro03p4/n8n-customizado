FROM n8nio/n8n:latest

USER root

# Investigar qual sistema operacional estamos usando
RUN echo "=== INVESTIGAÇÃO DO SISTEMA ===" && \
    cat /etc/os-release 2>/dev/null || echo "Sem /etc/os-release" && \
    ls -la /etc/ | grep release && \
    which python3 2>/dev/null || echo "Python3 não encontrado" && \
    which pip3 2>/dev/null || echo "Pip3 não encontrado" && \
    which apk 2>/dev/null || echo "APK não encontrado" && \
    which apt-get 2>/dev/null || echo "APT não encontrado" && \
    which yum 2>/dev/null || echo "YUM não encontrado" && \
    echo "=== FIM DA INVESTIGAÇÃO ==="

# Tentar usar Python já instalado
RUN python3 -m pip install --upgrade pip --user 2>/dev/null || echo "Pip upgrade falhou"

# Instalar bibliotecas usando método direto
RUN python3 -m pip install --user python-docx==0.8.11 || echo "python-docx falhou"

USER node

ENV PYTHON_PATH=/usr/bin/python3
EXPOSE 5678
CMD ["n8n", "start"]
