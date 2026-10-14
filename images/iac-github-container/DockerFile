# Oficial linux image
FROM ubuntu:22.04
#FROM ubuntu

# Define enviroments variables
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_VERSION=2.321.0

# Install dependencies
RUN  apt update && apt install -y \
    curl \
    git \
    unzip \
    wget \
    build-essential \
    net-tools \
    ca-certificates \ 
    jq \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system actions && adduser --system --ingroup actions --home /home/actions actions
#WORKDIR /home/actions

ENV AZURE_EXTENSION_DIR=/usr/local/azexts
ENV HOME=/home/actions
RUN mkdir -p ${AZURE_EXTENSION_DIR}

# Install  Github Action
RUN cd /home/actions && mkdir actions-runner && cd actions-runner \
    && wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install CLI and CLI Extension ML
RUN pip3 install azure-cli

RUN az config set extension.dynamic_install=yes_without_prompt && \
    az config set extension.use_dynamic_install=yes_without_prompt && \
    az config set extension.dynamic_install_allow_preview=true

# install ml cli extension
RUN az extension add -n ml --yes && \
    az extension list

# Install yq
RUN wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/v4.25.1/yq_linux_amd64" \
    && chmod +x /usr/local/bin/yq \
    && pip3 install promptflow --upgrade

# Copiar o certificado para o contêiner 
# Certificado deve estar no mesmo diretório do Dockerfile 


# Atualizar os certificados confiáveis no contêiner 
RUN chmod 644 /usr/local/share/ca-certificates/$CERT_FILE && update-ca-certificates  

# Configurar variáveis de proxy, se necessário 
# Descomente e personalize conforme necessário 
#ENV HTTPS_PROXY=""
#ENV HTTP_PROXY=""
#     NO_PROXY=localhost,127.0.0.1 

RUN chown -R actions ~actions 

WORKDIR /home/actions/actions-runner

RUN ./bin/installdependencies.sh

#RUN chown -R actions ~actions && /home/actions/actions-runner/bin/installdependencies.sh

COPY entrypoint.sh .
RUN chmod 777 ./entrypoint.sh

# Dar permissões de leitura/execução para o grupo ou todos no diretório de extensões
RUN chmod -R a+rx ${AZURE_EXTENSION_DIR}
USER actions

CMD ["bash", "-c", "while true; do sleep 30; done"]

ENTRYPOINT ["./entrypoint.sh"]


