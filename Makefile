PROJECT_NAME=promptly
DOCKERFILE_PATH=./docker/Dockerfile
BUILD_CONTEXT=..
DOCKER_COMPOSE_PATH=docker-compose.yml
DOCKER_COMPOSE= docker-compose  --env-file=.env

# Managing containers
build:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} build

up:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} up -d

down:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} down

clean:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} down --rmi all

start: build up

rebuild: clean start

logs:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} logs -f promptly

logs-db:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} logs -f db

shell-backend:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} exec promptly /bin/bash

# Alembic commands
alembic-upgrade:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} exec promptly alembic upgrade head
alembic-downgrade:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} exec promptly alembic downgrade -1
alembic-revision:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} exec promptly alembic revision --autogenerate -m "migration"
alembic-migrate: alembic-revision alembic-upgrade

# Tests
test:
	${DOCKER_COMPOSE} -f ${DOCKER_COMPOSE_PATH} exec promptly pytest -s tests/