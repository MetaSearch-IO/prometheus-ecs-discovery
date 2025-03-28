FROM golang:1.23
WORKDIR /src
COPY *.go go.mod go.sum ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o /bin/prometheus-ecs-discovery .

FROM arm64v8/ubuntu
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=0 /bin/prometheus-ecs-discovery /bin/
ENTRYPOINT ["/bin/prometheus-ecs-discovery"]
