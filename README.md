# TODO API

HTTP API written in Crystal.

Forms the server backend for the [TODO Checklist app](https://github.com/michaeltelford/todo) written in React. Backed by a PostgreSQL database. Uses Docker and docker-compose to form the infrastructure.

The actual application can be used by visiting:

https://todo-checklist.surge.sh

Auth is handled by Auth0. You can login using your Github or Google account. Or you can sign up for an Auth0 account. You are limited to 20 lists (with unlimited TODO's) per account.

## Rationale

A HTTP server was needed to build a working API and data model for the TODO frontend application. I choose Crystal because:

- It's similar in syntax to Ruby which I know and love. It's both fun and quick to develop with.
- It's blindingly fast! Sub 10ms response times (having pulled data from the DB) are an average, while running on a docker network.
- It compiles down into a native binary which makes for small Docker images, capable of being deployed anywhere.

## ENV

The following environment variables are required to run the server:

- CLIENT_AUTH_URI
- CLIENT_ID
- CLIENT_SECRET
- DATABASE_URL
- PORT
- TOKEN_EXCHANGE_URL
- RSA_PUBLIC_KEY

## Usage

At the root of the repo, running `make` will display help info on all available commands:

```
env    	    : Create an .env file for required variables.
build  	    : Build a local Crystal executable.
build_prod  : Build a production Crystal executable.
build_image : Build a production Docker image.
run    	    : Run the app for local dev using docker-compose.
test   	    : Run the tests.
deploy 	    : Deploy to production.
```

## Development

- It helps to have a local installation of Crystal. See the `.crystal-version` file for the correct version.
- You must have Docker (and docker-compose) installed for local development.

### RSA Public Key

The API uses an RSA public key to verify the JWT auth token (sent by the client). Follow these steps to find and save the key that the API uses:

- Open https://todo-checklist.auth0.com/pem in a browser.
- Download the PEM certificate to `~/Downloads`.
- Base64 encode the contents of the downloaded file using an online base64 encoder ensuring there are no `\n`'s anywhere.
- Set the `RSA_PUBLIC_KEY` ENV var with the encoded value.
- **Note**: If you get a login cycle, check the logs for '`token decode failure: Neither PUB or PRIV key: error: <reason>`' indicating that the `RSA_PUBLIC_KEY` isn't right.

## Testing

Until the automated unit tests are up and running you can do the following to manually test the API:

- Log into the todo checklist app and copy your auth'd `JWT_TOKEN` value from the browser.
- Open `.env` and set `JWT_TOKEN=<copied_value>`, then save the file.
- Start the API (using `make run`).
- Open the `requests.http` file in VSCode.
- Execute each request (in order, from top to bottom) ensuring that the expected response is returned.

## TODO

- Automated Unit Tests
- Validators

## Contributing

1. Fork it (<https://github.com/your-github-user/todo_api/fork>).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.

## Contributors

- [Michael Telford](https://github.com/michaeltelford) - creator and maintainer
