# syntax=docker/dockerfile:1

## Build
FROM golang:1.19-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /notification-service

## Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /notification-service /notification-service

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/notification-service"]