FROM alpine:3.4

RUN apk --update --no-cache add bash openssl

ENV CONSUL_VERSION 0.6.4
RUN wget -O consul.zip https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul.zip -d /bin && \
    rm consul.zip && \
    wget -O consul-web-ui.zip https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_web_ui.zip && \
    mkdir -p /lib/consul/ui && \
    unzip consul-web-ui.zip -d /lib/consul/ui && \
    rm consul-web-ui.zip

ENV CONTAINERPILOT file:///etc/containerpilot.json
ENV CONTAINERPILOT_VERSION 2.3.0
RUN wget -O - https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT_VERSION/containerpilot-$CONTAINERPILOT_VERSION.tar.gz | \
      tar xz -C /bin/

COPY bin/consul-health /bin/
COPY bin/consul-pre-start /bin/
COPY etc/consul.json /etc/
COPY etc/containerpilot.json /etc/

EXPOSE 53 53/udp 8300 8301 8301/udp 8302 8302/udp 8400 8500

ARG VERSION
ENV VERSION $VERSION

ENV CONSUL_URL localhost

ENTRYPOINT [ \
  "containerpilot", \
  "consul", \
  "agent", \
  "-config-file", \
  "/etc/consul.json" \
]
