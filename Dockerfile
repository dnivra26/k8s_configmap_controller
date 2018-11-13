FROM golang:alpine AS builder
RUN apk add --no-cache --update git
ENV GOPATH=/go

RUN go get -u github.com/golang/dep/cmd/dep


ADD . $GOPATH/src/configmap_restart_controller
WORKDIR $GOPATH/src/configmap_restart_controller

RUN go version

RUN dep ensure

RUN go build -o /go/bin/configmap_restart_controller

FROM alpine:latest

COPY --from=builder /go/bin/configmap_restart_controller /usr/local/bin/configmap_restart_controller

CMD configmap_restart_controller