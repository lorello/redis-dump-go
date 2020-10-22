FROM golang:1.14 as build

WORKDIR /go/src/github.com/yannh/redis-dump-go
COPY . .

ENV CGO_ENABLED=0
ENV GOOS=linux
RUN make build-static


FROM alpine:latest as certs
RUN apk add ca-certificates

FROM scratch AS redis-dump-go
MAINTAINER Yann HAMON <yann@mandragor.org>
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/github.com/yannh/redis-dump-go/bin/redis-dump-go /
ENTRYPOINT ["/redis-dump-go"]
