#!/usr/bin/env bash
set -eux
# Requirements:
# - can't use docker buildx, it's too hard :sigh:
# - need to enable preview feature (new registry, ghcr.io) -- https://docs.github.com/en/free-pro-team@latest/packages/guides/migrating-to-github-container-registry-for-docker-images
# - pobably has issues when we want to do dynamic naming (but maybe we can just tag with commit)

# TODO create-or-use
# --load
# docker buildx inspect --bootstrap
env DOCKER_CLI_EXPERIMENTAL=enabled \
	docker buildx \
		"build" "--progress=plain" "--file=Dockerfile" \
		"--build-arg=DHALL_VERSION=1.37.1" "--build-arg=DHALL_JSON_VERSION=1.7.4" "--build-arg=DHALL_YAML_VERSION=1.2.4" "--build-arg=BUILDKIT_INLINE_CACHE=1" "--cache-from=docker.pkg.github.com/timbertson/dhall-ci/dhall:latest" "--cache-from=docker.pkg.github.com/timbertson/dhall-ci/dhall:$(echo "$(if [[ -n ${GITHUB_HEAD_REF:-} ]]; then echo "$GITHUB_HEAD_REF"; else echo "${GITHUB_REF##refs/heads/}"; fi)" | tr / -)" \
		"--cache-to=type=registry,mode=max,ref=docker.pkg.github.com/timbertson/dhall-ci/dhall:$GITHUB_SHA" \
		"."

		# "--tag=docker.pkg.github.com/timbertson/dhall-ci/dhall:$GITHUB_SHA" \
		# "--tag=docker.pkg.github.com/timbertson/dhall-ci/dhall:$(echo "$(if [[ -n ${GITHUB_HEAD_REF:-} ]]; then echo "$GITHUB_HEAD_REF"; else echo "${GITHUB_REF##refs/heads/}"; fi)" | tr / -)" \
