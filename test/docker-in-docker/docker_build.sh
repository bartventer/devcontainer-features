#!/bin/bash

set -e

# Optional: Import test library
# shellcheck disable=SC1091
source dev-container-features-test-lib

# Definition specific tests
check "docker-daemon-check" bash -c "./_docker_daemon_check.sh"
check "docker-buildx" docker buildx version
check "docker-build" docker build ./

check "installs compose-switch" bash -c "[[ -f /usr/local/bin/compose-switch ]]"
check "docker compose" bash -c "docker compose version | grep -E '2.[0-9]+.[0-9]+'"
check "docker-compose" bash -c "docker-compose --version | grep -E '2.[0-9]+.[0-9]+'"

check "docker-buildx" bash -c "docker buildx version"
check "docker-buildx-path" bash -c "ls -la /usr/lib/docker/cli-plugins/docker-buildx"

# Report result
reportResults