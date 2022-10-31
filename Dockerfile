FROM alpine:3.16

ENV DOCKER_HOST unix:///var/run/docker.sock

RUN apk --no-cache add curl binutils s6-overlay dnsmasq

RUN wget https://github.com/nginx-proxy/docker-gen/releases/download/0.9.0/docker-gen-alpine-linux-amd64-0.9.0.tar.gz && \
  tar xvzf docker-gen-alpine-linux-amd64-0.9.0.tar.gz -C /usr/local/bin

COPY files/. /

EXPOSE 53/udp

ENTRYPOINT ["/init"]
