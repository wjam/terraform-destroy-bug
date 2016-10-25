#!/usr/bin/env bash

set -e

docker_ip=${1:-localhost}

consul_address=${docker_ip}:8500

curl -X PUT -d 'example contents' ${consul_address}/v1/kv/file_contents
curl -X PUT -d 'dc1' ${consul_address}/v1/kv/consul_datacenter
curl -X PUT -d 'http' ${consul_address}/v1/kv/consul_scheme
