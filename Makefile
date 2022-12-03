.PHONY: help env build build_prod build_image run test deploy

help:
	@echo ""
	@echo "TODO API"
	@echo "--------"
	@echo ""
	@echo "env    	    : Create an .env file for required variables."
	@echo "build  	    : Build a local Crystal executable."
	@echo "build_prod  : Build a production Crystal executable."
	@echo "build_image : Build a production Docker image."
	@echo "run    	    : Run the app for local dev using docker-compose."
	@echo "test   	    : Run the tests."
	@echo "deploy 	    : Deploy to production."
	@echo ""

env:
	echo 'CLIENT_AUTH_URI=\nCLIENT_ID=\nCLIENT_SECRET=\nTOKEN_EXCHANGE_URL=\nRSA_PUBLIC_KEY=' > .env

build:
	@-mkdir bin 2>/dev/null || true
	crystal build ./src/todo_api.cr -o ./bin/todo_api

build_prod:
	@-mkdir bin 2>/dev/null || true
	docker run --rm -it -v ${PWD}:/app -w /app \
	crystallang/crystal:1.6.2-alpine \
	crystal build ./src/todo_api.cr -o ./bin/todo_api \
	--progress --release --static --no-debug

build_image:
	docker build -f prod.dockerfile -t todo_api_prod .

run:
	@echo "Run 'guard' to restart the API when src/*.cr files change."
	TODO_ENV=development POSTGRES_DB=app docker-compose up

test:
	@echo "Clearing db containers before and after the tests."
	docker rm -f db 2>/dev/null || true
	TODO_ENV=test POSTGRES_DB=test docker-compose run --rm api crystal spec || true
	docker rm -f db

deploy:
	@echo "Follow these steps to deploy to production:"
	@echo "- Push your code to 'master'"
	@echo "- Login to render.com"
	@echo "- Manually deploy the latest commit from the dashboard"
