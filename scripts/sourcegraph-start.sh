#!/bin/bash

docker run --publish 7080:7080 \
	--publish 127.0.0.1:3370:3370 --rm \
	--volume ~/.sourcegraph/config:/etc/sourcegraph \
	--volume ~/.sourcegraph/data:/var/opt/sourcegraph \
	sourcegraph/server:3.12.3
