# TODO API

HTTP API written in Crystal.

Forms the server backend for the [TODO Checklist app](https://github.com/michaeltelford/todo) written in React. Backed by a PostgreSQL database. Uses Docker and docker-compose to form the infrastructure.

The actual application can be used by visiting:

https://todo-checklist.surge.sh

Auth is handled by Auth0. You can login using your Github or Google account. Or you can sign up for an Auth0 account. You are limited to 5 lists (with unlimited TODO's) per account.

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

## Usage

At the root of the repo, you can run the following commands:

```sh
make build  # Builds the production Docker alpine image.
make run    # Run the API and DB containers locally (for dev/testing).
make test   # Run the tests (also using docker-compose).
```

Running `make` will display help info on all available commands.

## Development

- You must have a working installation of Crystal. See the `.crystal-version` file for the correct version.
- You must have Docker (and docker-compose) installed for local development.

### RSA Public Key

The API uses an RSA public key to verify the JWT auth token (sent by the client). Follow these steps to find and save the key that the API uses:

- Open Auth0 and login (requires credentials)
- Open the `TODO Checklist` app
- Go to `Settings -> Advanced Settings -> Certificates`
- Download the PEM certificate to `~/Downloads`
- Open a shell at the repo's root directory
- Run the following command to save the public RSA key to file:
  ```
  openssl x509 -pubkey -noout -in ~/Downloads/todo-checklist.pem > id_rsa.pub
  ```

## Contributing

1. Fork it (<https://github.com/your-github-user/todo_api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Michael Telford](https://github.com/michaeltelford) - creator and maintainer
