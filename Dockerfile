#that is just a simple Dockerfile to build the app for testing purposes

FROM golang:1.23.1

WORKDIR /go/src/app

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 go build -o /app ./main.go

CMD ["/app"]
