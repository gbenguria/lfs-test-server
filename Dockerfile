FROM golang:1.19.5 AS builder
MAINTAINER GitHub, Inc.

WORKDIR /go/src/github.com/git-lfs/lfs-test-server

COPY . .

RUN go build

FROM ubuntu:jammy

EXPOSE 8080

COPY --from=builder /go/src/github.com/git-lfs/lfs-test-server/lfs-test-server /bin/lfs-test-server

ARG TUSD_DEB_URL=https://github.com/tus/tusd/releases/download/v1.10.1/tusd_snapshot_amd64.deb

RUN apt-get update && apt-get install -y wget jq && \
    wget -O tusd.deb $TUSD_DEB_URL && \
    dpkg -i tusd.deb && \
    rm tusd* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

CMD /bin/lfs-test-server