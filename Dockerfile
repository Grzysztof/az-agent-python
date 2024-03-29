FROM ubuntu:20.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    python3-pip \
    && apt clean

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp
# Copy docker
COPY --from=docker:20.10 /usr/local/bin/docker /usr/local/bin/

COPY ./start.sh .
RUN chmod +x start.sh

RUN useradd agent
RUN chown agent ./
USER agent

ENTRYPOINT [ "./start.sh" ]
