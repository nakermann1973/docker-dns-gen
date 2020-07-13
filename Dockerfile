FROM alpine:latest

ARG ĴWILDER_DOCKER_GEN_VERSION=0.7.4
ARG JWILDER_DOCKER_GEN_RELEASE=https://github.com/jwilder/docker-gen/releases/download/${ĴWILDER_DOCKER_GEN_VERSION}/docker-gen-alpine-linux-amd64-${ĴWILDER_DOCKER_GEN_VERSION}.tar.gz
ARG JWILDER_DOCKER_GEN_FILE=/tmp/docker-gen.tar.gz
ARG S6_OVERLAY_RELEASE=https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz
ARG S6_OVERLAY_FILE=/tmp/s6overlay.tar.gz
ENV DOCKER_HOST unix:///var/run/docker.sock

RUN \
  apk --no-cache add \
    curl \
    dnsmasq

RUN \
  curl -L ${S6_OVERLAY_RELEASE} -o ${S6_OVERLAY_FILE} && \
  tar xzf ${S6_OVERLAY_FILE} -C / && \
  rm ${S6_OVERLAY_FILE}

RUN \
  curl -L ${JWILDER_DOCKER_GEN_RELEASE} -o ${JWILDER_DOCKER_GEN_FILE} && \
  tar xzf ${JWILDER_DOCKER_GEN_FILE} -C /usr/local/bin && \
  rm ${JWILDER_DOCKER_GEN_FILE}

COPY files/. /

EXPOSE 53/udp

ENTRYPOINT ["/init"]
