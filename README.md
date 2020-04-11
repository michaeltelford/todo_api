# TODO API

HTTP API written in Crystal.

Forms the server backend for the TODO Checklist app written in React. Backed by a PostgreSQL database. Uses Docker and docker-compose to form the infrastructure.

## Rationale

A HTTP server was needed to build a working API and data model for the TODO frontend application. I choose Crystal because:

- It's similar in syntax to Ruby which I know and like. It's both fun and quick to develop with.
- It's blindingly fast! Sub 10ms response times (having pulled data from the DB) are an average, while running on a docker network.
- It compiles down into a native binary which makes for small Docker images, capable of being deployed anywhere.

## ENV

The following environment variables are required to run the server:

- PORT
- DB_CONNECTION_STRING
- SESSIONS_SECRET
- SECURE_SESSIONS
- TOKEN_EXCHANGE_URL
- CLIENT_ID
- CLIENT_SECRET
- CLIENT_AUTH_URI

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

## Contributing

1. Fork it (<https://github.com/your-github-user/todo_api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Michael Telford](https://github.com/michaeltelford) - creator and maintainer
