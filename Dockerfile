FROM golang:1.15.6-alpine as builder

COPY . /go/src/github.com/pyr-sh/concourse-ssh-resource

RUN apk --no-cache add make && \
  cd /go/src/github.com/pyr-sh/concourse-ssh-resource && \
  make build-linux

FROM alpine:3.12

COPY --from=builder /opt/resource /opt/resource
