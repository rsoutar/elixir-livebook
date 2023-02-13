FROM livebook/livebook:0.8.1

RUN mix local.hex --force \
  && mix archive.install hex phx_new --force \
  && mix local.rebar --force

RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    erlang-dev \
    gnupg2 \
    lsb-release \
    sudo \
    unzip \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For Docker
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y docker.io \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ./livebooks /home/livebook

CMD ["/app/bin/livebook", "start"]
