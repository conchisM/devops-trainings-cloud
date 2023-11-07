FROM golang:1.21 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./
COPY *.png ./
COPY tpl/ ./tpl/

RUN CGO_ENABLED=0 go build -o /main


FROM gcr.io/distroless/static-debian12:latest-amd64

COPY --from=builder /main /main

EXPOSE 8080

ENTRYPOINT ["/main"]
