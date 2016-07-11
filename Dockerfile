FROM alpine:3.4

RUN apk --update --no-cache add openssl

ENV CONSUL_VERSION 0.6.4
RUN wget -O consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul.zip -d /usr/local/bin && \
    rm consul.zip && \
    wget -O consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip && \
    mkdir -p /usr/local/lib/consul-web-ui && \
    unzip consul-web-ui.zip -d /usr/local/lib/consul-web-ui && \
    rm consul-web-ui.zip

ENV CONTAINERPILOT_VERSION 2.3.0
RUN wget -O - https://github.com/joyent/containerpilot/releases/download/$CONTAINERPILOT_VERSION/containerpilot-$CONTAINERPILOT_VERSION.tar.gz | \
      tar xz -C /usr/local/bin/

EXPOSE 53 53/udp 8300 8301 8301/udp 8302 8302/udp 8400 8500

ARG VERSION
ENV VERSION $VERSION
