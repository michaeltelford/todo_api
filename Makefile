.PHONY: help env build run test

help:
	@echo ""
	@echo "TODO API"
	@echo "--------"
	@echo ""
	@echo "env    : Create an .env file for required variables."
	@echo "build  : Build a production alpine docker image."
	@echo "run    : Run the app for development using docker-compose."
	@echo "test   : Run the tests."
	@echo "deploy : Deploy to prod."
	@echo ""

env:
	echo 'CLIENT_AUTH_URI=\nCLIENT_ID=\nCLIENT_SECRET=\nRSA_PUBLIC_KEY=\nTOKEN_EXCHANGE_URL=' > .env

build:
	@-mkdir bin 2>/dev/null || true
	docker run --rm -it -v ${PWD}:/app -w /app \
	crystallang/crystal:0.33.0-alpine \
	crystal build ./src/todo_api.cr -o ./bin/todo_api \
	--progress --release --static --no-debug

run:
	@echo "Run 'guard' to restart the API when src/*.cr files change."
	KEMAL_ENV=development POSTGRES_DB=app docker-compose up

test:
	@echo "Clearing db containers before and after the tests."
	docker rm -f db 2>/dev/null || true
	KEMAL_ENV=test POSTGRES_DB=test docker-compose run --rm api crystal spec || true
	docker rm -f db

deploy:
	git push heroku master
