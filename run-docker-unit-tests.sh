#!/bin/bash
. .env

(set -ex
  docker build \
    -t kong-auth0-unit-tests \
    -f tests/Dockerfile .
  docker run -it --rm kong-auth0-unit-tests /bin/bash tests/run.sh
)

echo "Done"