DOCKER_COMPOSE ?= $(shell if docker compose version >/dev/null 2>&1; then printf '%s' 'docker compose'; elif command -v docker-compose >/dev/null 2>&1; then printf '%s' 'docker-compose'; else printf '%s' 'docker compose'; fi)
DOCKER_IMAGE ?= javascript-fastify-blog

setup: install db-migrate

install:
	npm install

db-migrate:
	npm run migrate

build:
	npm run build

prepare-env:
	cp -n .env.example .env

start:
	NODE_ENV=production npm run start

dev:
	npx concurrently "make start-frontend" "make start-backend"

start-backend:
	npm start -- --watch --verbose-watch --ignore-watch='node_modules .git .sqlite'

start-frontend:
	npx webpack --watch --progress

lint:
	npx eslint .

lint-fix:
	npx eslint --fix .

test:
	NODE_ENV=test npm test -s

docker-build:
	$(DOCKER_COMPOSE) build app

docker-dev:
	$(DOCKER_COMPOSE) up --build app

docker-test:
	$(DOCKER_COMPOSE) --profile test up --build --abort-on-container-exit --exit-code-from test test

docker-down:
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

docker-image:
	docker build --target production -t $(DOCKER_IMAGE):latest .
