#!/bin/bash

docker build -t aixtract-dev:dev -f $(pwd)/Dockerfile-dev .
docker run -it --rm -v $(pwd):/ws --network host aixtract-dev:dev /bin/bash