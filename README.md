# Project Red

## Purpose

Provides a way to scaffold a new Ruby on Rails project into a docker container, with your project source bind mounted into the container from a cloned version of the repo on your host machine.

This method allows you to run the application within the container with its own ruby and rails versioning, whilst simultaneously letting you edit the source from your host machine tools.

## Provides

- latest released Ruby
- latest released Rails set to be scaffolded for:
   - postgresql
   - rspec
   - factorybot
   - bun
   - tailwind
   - react.js
- latest released Postgresql

## Requirements

- docker (or something sufficiently compatible with docker-compose such as podman)
- docker-compose (v2)
- a bash shell

## Usage

Clone this repo to one with your desire project name and then in that repo do:

```shell
./init-new-project.sh
```

Then use `docker compose` to bring up the application:

```shell
docker compose run web bin/dev
```
