#!/bin/bash
set -e
if [ "$ENV" = 'DEV' ]; then
  echo "Running Development Server"
  exec python "app.py"
else
  echo "Running Production Server"
  exec uwsgi --http 0.0.0.0:9000 --wsgi-file ./app.py \
             --callable app
fi