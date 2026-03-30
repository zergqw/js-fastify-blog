# JS Fastify Blog

## Requirements

- Docker and Docker Compose for containerized development
- Node.js 20+ for running the project without Docker

## Local development in Docker

Prepare a local `.env` file:

```bash
make prepare-env
```

Start the application and PostgreSQL:

```bash
make docker-dev
```

The application will be available at `http://localhost:8080`.

## Running tests in Docker

```bash
make docker-test
```

## Building a production image

```bash
make docker-image
docker run --rm -p 8080:8080 \
  -e DATABASE_NAME=postgres \
  -e DATABASE_USERNAME=postgres \
  -e DATABASE_PASSWORD=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_HOST=<postgres-host> \
  javascript-fastify-blog:latest
```

For a standalone container, point `DATABASE_HOST` to an external PostgreSQL host that is reachable from the container.

## Local development without Docker

If database environment variables are not specified, the project falls back to SQLite for `development` and `test`.

```bash
make install
make dev
```

To use PostgreSQL outside Docker, prepare `.env` and specify the connection settings:

```dotenv
DATABASE_NAME=postgres
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_PORT=5432
DATABASE_HOST=localhost
```

## CI and publishing

GitHub Actions runs lint and tests inside Docker containers. On pushes to `main`, the workflow builds the production image and publishes it to Docker Hub.

Required repository secrets:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

---

[![Hexlet Ltd. logo](https://raw.githubusercontent.com/Hexlet/assets/master/images/hexlet_logo128.png)](https://hexlet.io?utm_source=github&utm_medium=link&utm_campaign=js-fastify-blog)

This repository is created and maintained by the team and the community of Hexlet, an educational project. [Read more about Hexlet](https://hexlet.io?utm_source=github&utm_medium=link&utm_campaign=js-fastify-blog).

See most active contributors on [hexlet-friends](https://friends.hexlet.io/).
