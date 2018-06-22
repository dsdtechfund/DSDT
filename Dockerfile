FROM erlang:20.2

RUN mkdir -p /opt/dsdtchain
WORKDIR /opt/dsdtchain

## Fetch / Compile deps
ADD rebar.config rebar.config
ADD rebar.lock rebar.lock
RUN rebar3 get-deps
RUN rebar3 compile

## Add / Compile source
ADD src/ src/
ADD config/ config/
RUN rebar3 compile

ADD scripts/ scripts/
RUN chmod +x scripts/docker.sh

EXPOSE 8333

CMD ["./scripts/docker.sh"]
