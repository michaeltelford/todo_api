.PHONY: help build run

help:
	@echo ""
	@echo "TODO API"
	@echo "--------"
	@echo ""
	@echo "build : Build the production alpine docker image."
	@echo "run   : Run the app for development using docker-compose."
	@echo ""

build:
	@-mkdir bin 2>/dev/null || true
	docker run --rm -it -v ${PWD}:/app -w /app \
	crystallang/crystal:0.33.0-alpine \
	crystal build ./src/todo_api.cr -o ./bin/todo_api \
	--progress --release --static --no-debug

run:
	@echo "Run 'guard' to restart the API when src/*.cr files change."
	docker-compose up
