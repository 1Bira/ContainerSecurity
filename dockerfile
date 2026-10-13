FROM ubuntu:24.04

ENV TARGETARCH="linux-x64" \
    DEBIAN_FRONTEND="noninteractive"

# Also can be "linux-arm", "linux-arm64".
RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      gnupg \
      jq \
      libicu74 \
      lsb-release \
      make \
      unzip; \
    apt-get install -y --only-upgrade libssl3 openssl libtiff6 openssh-client libgdk-pixbuf-2.0-0; \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash; \
    # Lift vulnerable Python libraries inside Azure CLI's bundled runtime.
    /opt/az/bin/python3 -m pip install --no-cache-dir --upgrade \
      "cryptography>=46.0.7" \
      "PyJWT>=2.12.0" \
      "pyOpenSSL>=26.0.0" \
      "requests>=2.33.0" \
      "Pygments>=2.20.0"; \
    /opt/az/bin/python3 -m pip check; \
    apt-get purge -y --auto-remove gnupg lsb-release; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]