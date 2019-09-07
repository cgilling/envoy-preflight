# Build container
FROM golang:alpine AS builder

RUN apk -v --update add --no-cache \
    git

WORKDIR /build

ENV CGO_ENABLED=0
ENV GOOS=linux

ADD go.mod .
ADD go.sum .
RUN go mod download

ADD . .

RUN go build -o /envoy-preflight

# -----

# Runtime container
FROM busybox

COPY --from=builder /envoy-preflight /usr/local/bin/envoy-preflight
