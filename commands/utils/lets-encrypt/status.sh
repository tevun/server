#!/usr/bin/env bash

__require_docker
docker exec acme-companion /app/cert_status
