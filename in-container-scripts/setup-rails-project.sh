#!/usr/bin/env bash
project_name=${PWD##*/}

# it would be nice to do this in the actual Dockerfile but bind mounts + rails new creating a subdir
# make that a problem for another day

# rails initial project scaffold
rails new /tmp/$project_name -T -j esbuild -c tailwind -d postgresql --skip-docker
rm -r /tmp/$project_name/.git
cp -ar /tmp/$project_name/. .
bundle add rspec-rails factory_bot_rails --group "development, test"
bundle install
bin/rails g rspec:install

# make sure that application is visible outside the docker container
sed -i 's/server$/server -b 0\.0\.0\.0/' Procfile.dev
