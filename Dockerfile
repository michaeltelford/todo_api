FROM crystallang/crystal:1.6.2-alpine AS builder
WORKDIR /app
RUN mkdir bin
COPY . .
RUN crystal build ./src/todo_api.cr -o ./bin/todo_api \
	--progress --release --static --no-debug

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root
COPY --from=builder /app/bin/todo_api ./
CMD ["./todo_api"]
