<!--
  **NOTE**: this file is generated by `dhall-render`.
  You should NOT edit it manually, your changes will be lost.
-->

[![ci](https://github.com/timbertson/dhall-ci/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci/actions/workflows/ci.yml) [![update](https://github.com/timbertson/dhall-ci/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci/actions/workflows/update.yml)

<img src="http://gfxmonk.net/dist/status/project/dhall-ci.png">

# :warning: this project is inactive, see [chored](https://github.com/timbertson/chored) instead

Maintaining CI for many homogenous repositories is a huge pain.

Dhall provides (I believe) a very well-fitting solution to this problem, because it's:

 - simple (much easier to learn than a full programming language)
 - distributed (import code straight from the internet)
 - strongly typed (more errors at compile time = less error at the end of a slow CI build)

# Getting started:

```
curl -sSL 'https://raw.githubusercontent.com/timbertson/dhall-ci/master/bootstrap.sh' | bash
```

This will populate a minimal set of files in the current directory (`dhall/files.dhall` and `dhall/dependencies/CI.dhall`), and then run an initial file generation.

# Components:

This solution is intentionally decentralised, because:

 - a single repository trying to solve every use case is not going to scale well, and I don't want to have to curate libraries for ecosystems I have never used
 - it's a good opportunity to dogfood the ergonomics of this setup itself, since each component's CI setup is maintained using `dhall-ci`

By building it decentralised in the first place, anyone can contribute to the ecosystem by simply following the common patterns.

If you build your own component and want people to discover it, raise an issue / PR and I'll happily link it here:


| Repository | Description | Status |
|------------|-------------|--------|
| [dhall-ci](https://github.com/timbertson/dhall-ci) | (this repo): core types used by many modules (bash, workflow, etc) | [![ci](https://github.com/timbertson/dhall-ci/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci/actions/workflows/ci.yml)<br>[![update](https://github.com/timbertson/dhall-ci/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci/actions/workflows/update.yml) |
| [dhall-ci-dhall](https://github.com/timbertson/dhall-ci-dhall) | linting, formatting, freezing | [![ci](https://github.com/timbertson/dhall-ci-dhall/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci-dhall/actions/workflows/ci.yml)<br>[![update](https://github.com/timbertson/dhall-ci-dhall/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci-dhall/actions/workflows/update.yml) |
| [dhall-ci-docker](https://github.com/timbertson/dhall-ci-docker) | building, pushing & running docker images | [![ci](https://github.com/timbertson/dhall-ci-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci-docker/actions/workflows/ci.yml)<br>[![update](https://github.com/timbertson/dhall-ci-docker/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci-docker/actions/workflows/update.yml) |
| [dhall-ci-git](https://github.com/timbertson/dhall-ci-git) | committing, diffing and version management | [![ci](https://github.com/timbertson/dhall-ci-git/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci-git/actions/workflows/ci.yml)<br>[![update](https://github.com/timbertson/dhall-ci-git/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci-git/actions/workflows/update.yml) |

### Aggregate projects:

From these raw components, it's useful to build high level, opinionated
modules. These suit very narrow use cases, but are extremely useful
when you have a lot of near-identical repositories.


| Repository | Description | Status |
|------------|-------------|--------|
| [dhall-ci-timbertson](https://github.com/timbertson/dhall-ci-timbertson) | My own high-level project types (e.g. Scala library, Nix) | [![ci](https://github.com/timbertson/dhall-ci-timbertson/actions/workflows/ci.yml/badge.svg)](https://github.com/timbertson/dhall-ci-timbertson/actions/workflows/ci.yml)<br>[![update](https://github.com/timbertson/dhall-ci-timbertson/actions/workflows/update.yml/badge.svg)](https://github.com/timbertson/dhall-ci-timbertson/actions/workflows/update.yml) |

# Rendering files:

The components of `dhall-ci` are useful for defining things (workflows, scripts, etc). But that's not sufficient on its own. [timbertson/dhall-render](https://github.com/timbertson/dhall-render) is a tool which allows you to define a whole set of files, and have them rendered out as YAML / JSON / text.

To initialize dhall-render in a repository, run:

```
curl -sSL https://raw.githubusercontent.com/timbertson/dhall-render/master/bootstrap.sh | bash
```

## Updating files:

`dhall-render` provides a file (which will be generated in your repo) to bump a github dependency. Simply run e.g. `./dhall/bump dhall/dependencies/CI.dhall`.

For dependencies that aren't just pulled from a github commit (e.g. dhall's prelude), you will need to manually edit the version number and then run `dhall freeze --inplace dhall/dependencies/Prelude.dhall`

# Contents:

This repo contains some core types and functionality which is referenced by multiple components. For templates, helpers and opinionated templates you should also import the various components above.

### Bash:

An overly simple, leaky abstraction for authoring bash scripts.

This is in some ways the inverse of `dhall-bash` - that lets you represent dhall data structures in a way that bash scripts can read them, while this provides functions for composing dhall strings and lists into an executable bash script.

This makes no attempt at understanding the syntax or escaping rules for bash, it's really just "a list of lines".

It's not useful for composing expressions, but it _is_ useful for composing commands, conditionals, etc.

It has some opinions, namely that every script shall use `set -eu -o pipefail`. The `renderScript` enforces this, and snippets may not do the right thing if you use them in a script without these settings.

### Make:

Similar to `Bash`, this is a minimal abstraction for defining makefiles.

Because it is designed to represent arbitrary bash snippets (and not make heavy use of make features), makefiles generated by this module set (and rely on) the following features:

 - [`.ONESHELL:`](https://www.gnu.org/software/make/manual/html_node/One-Shell.html) is enabled, meaning the entire body of a target is treated as a single command
 - `SHELL`: set to `bash`
 - `.SHELLFLAGS`: set to `-eux -o pipefail`, i.e. `Bash.strict` with tracing enabled
 - each target is prefixed with `.SILENT: targetName`, to prevent make's builtin echoing (it doesn't work well with `.ONESHELL`, and is made redundant by bash's tracing)

When writing your own targets you should be mindful of these non-default options.

### Workflow:

This module contains the types for generating [github workflow](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions) documents.

It's a minimal wrapping of [regadas/github-actions-dhall](https://github.com/regadas/github-actions-dhall), with the following additions:

 - The toplevel export is the `Workflow` schema, merged with sub-properties for other types (`Job`, `Step`, etc).
 - Addition of the [Env](./Env.dhall), [JobMap](./JobMap.dhall)
 - The [Step](./Step.dhall) contains extra utilities (integration with the [Bash](../Bash/) module, `addEnv`, etc)

# Development workflow

Unfortunately, dhall doesn't make it super easy to "sub in" overrides during development. `dhall-render` provides the `dhall/local` script to make this more convenient. Usage:

```
./dhall/local ./dhall/render
```

This finds all `*.dhall.local` files, and _temporarily_ replaces the corresponding `*.dhall` file, then runs the supplied command.

Upon termination, it restores the original contents of the `*.dhall` files, so it should result in no actual changes to your workspace.
But note that it does actually move files around on disk, so it's not safe to run concurrently.
