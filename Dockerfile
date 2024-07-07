

# syntax = docker/dockerfile:1

FROM ruby as base

RUN apt-get update &&\
    apt-get install --yes git curl build-essential

RUN curl -sL https://deb.nodesource.com/setup_current.x | bash - &&\
    apt-get update && \
    apt-get install --yes --no-install-recommends nodejs &&\
    npm install -g yarn

FROM base as build

ARG APPNAME
ENV APPNAME=${APPNAME}

RUN gem install rails

WORKDIR /${APPNAME}

ENV RAILS_ENV=development
EXPOSE 3000

CMD if [ -f "./bin/dev" ]; then ./bin/dev; fi;
