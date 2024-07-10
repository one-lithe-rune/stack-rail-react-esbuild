#!/usr/bin/env bash

echo ""; echo "Clearing uncommitted files for '$project_basename'..."; echo ""

git checkout main
rm ./.gitignore
git clean -df
git checkout -- .
git checkout init-project