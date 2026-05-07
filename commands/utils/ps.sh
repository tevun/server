#!/usr/bin/env bash

__require_docker
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"