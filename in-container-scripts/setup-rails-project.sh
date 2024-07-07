#!/usr/bin/env bash
project_name=${PWD##*/}

# TODO: push as much of this as we can into the Dockerfile

# rails initial project scaffold
rails new /tmp/$project_name -T -j esbuild -c tailwind -d postgresql --skip-docker
rm -r /tmp/$project_name/.git
cp -ar /tmp/$project_name/. .
bundle add rspec-rails factory_bot_rails --group "development, test"
bundle install
bin/rails g rspec:install

# javascript dependencies
yarn add react react-dom

# stub rails controller and views
bin/rails generate controller Time index

# stub react app and components
cat << "EOF" >> app/javascript/application.js
import "./components/counter"
EOF

mkdir app/javascript/components

cat << "EOF" >> app/javascript/components/counter.jsx
import React, { useState, useEffect, useRef } from 'react';
import { createRoot } from 'react-dom/client';

const Counter = ({ arg }) => {
  const [count, setCount] = useState(0);
  const countRef = useRef(count);
  countRef.current = count;

  useEffect(() => {
    const interval = setInterval(() => {
      setCount(countRef.current + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  return <div>{`${arg} - counter = ${count}!`}</div>;
};

document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("root");
  const root = createRoot(container);
  root.render(<Counter arg={`
    Node ${container.getAttribute('node')}
    Ruby ${container.getAttribute('ruby')}
    Rails ${container.getAttribute('rails')}`} />);
});
EOF

cat << "EOF" >> app/views/time/index.html.erb
<!DOCTYPE html>
<html>
<head>
<style>
body {
  margin: 0;
}

svg {
  height: 40vmin;
  pointer-events: none;
  margin-bottom: 1em;
}

@media (prefers-reduced-motion: no-preference) {
  svg {
    animation: App-logo-spin infinite 20s linear;
  }
}

main {
  background-color: #282c34;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
  color: white;
}

@keyframes App-logo-spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
</head>
<body>
<main>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-11.5 -10.23174 23 20.46348">
  <title>React Logo</title>
  <circle cx="0" cy="0" r="2.05" fill="#61dafb"/>
  <g stroke="#61dafb" stroke-width="1" fill="none">
    <ellipse rx="11" ry="4.2"/>
    <ellipse rx="11" ry="4.2" transform="rotate(60)"/>
    <ellipse rx="11" ry="4.2" transform="rotate(120)"/>
  </g>
</svg>
<div id="root"
  node=<%= `node -v`.strip.sub(/^v/, '') %>
  ruby=<%= RUBY_VERSION %>
  rails=<%= Rails::VERSION::STRING %>>
</div>
</main>
</body>
</html>
EOF

cat << "EOF" >> config/routes.rb
  Rails.application.routes.draw { root "time#index" }
EOF

# make sure that application is visible outside the docker container
sed -i 's/server$/server -b 0\.0\.0\.0/' Procfile.dev
