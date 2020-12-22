# This is just for a development shell, it doesn't run anything
# TODO build a super tiny shell with nix?

FROM alpine

RUN apk add \
	bash \
	curl \
	git \
	make \
	ruby \
	ruby-json \
	;

# These versions are set in `files.dhall`
ARG DHALL_VERSION
ARG DHALL_JSON_VERSION
ARG DHALL_YAML_VERSION

RUN bash -xc 'curl -sSL "https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-$DHALL_VERSION-x86_64-linux.tar.bz2" | tar -C /usr -xj'
RUN bash -xc 'curl -sSL "https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-json-$DHALL_JSON_VERSION-x86_64-linux.tar.bz2" | tar -C /usr -xj'
RUN bash -xc 'curl -sSL "https://github.com/dhall-lang/dhall-haskell/releases/download/$DHALL_VERSION/dhall-yaml-$DHALL_YAML_VERSION-x86_64-linux.tar.bz2" | tar -C /usr -xj'

# breakme...
RUN false

WORKDIR /
