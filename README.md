# :warning: work in progress

Maintaining CI for many homogenous repositories is a huge pain.

Dhall provides (I believe) a very well-fitting solution to this problem, because it's:

 - simple (much easier to learn than a full programming language)
 - distributed (import code straight from the internet)
 - strongly typed (more errors at compile time = less error at the end of a slow CI build)

# Components:

This solution is intentionally decentralised, because:

 - a single repository trying to solve every use case is not going to scale well, and I don't want to have to curate libraries for ecosystems I have never used
 - dhall's remote imports are low friction compared to most languages, so there's little downside

By building it decentralised in the first place, anyone can contribute to the ecosystem by simply following the common patterns.

If you build your own component and want people to discover it, raise an issue / PR and I'll happily link it here:

- [timbertson/dhall-ci](https://github.com/timbertson/dhall-ci) (this repo): core types used by many modules (bash, workflow, etc)
- [timbertson/dhall-ci-dhall](https://github.com/timbertson/dhall-ci-dhall): linting, formatting, freezing
- [timbertson/dhall-ci-docker](https://github.com/timbertson/dhall-ci-docker): building, pushing & running docker images
- [timbertson/dhall-ci-git](https://github.com/timbertson/dhall-ci-git): committing, diffing and version management

# Rendering files:

The components of `dhall-ci` are useful for defining things (workflows, scripts, etc). But that's not sufficient on its own. [timbertson/dhall-render](https://github.com/timbertson/dhall-render) is a tool which allows you to define a whole set of files, and have them rendered out as YAML / JSON / text.

To initialize dhall-render in a repository, run:

```
curl -sSL https://raw.githubusercontent.com/timbertson/dhall-render/master/bootstrap.sh | bash
```

## Suggested usage:

The recommended way to import `dhall-ci-*` functionality is to merge additional components on top of the base CI package, like this:

```dhall
-- dhall/CI.dhall
https://raw.githubusercontent.com/timbertson/dhall-ci/COMMIT_OR_TAG/package.dhall /\
{
	, Git = https://raw.githubusercontent.com/timbertson/dhall-ci-git/COMMIT_OR_TAG/package.dhall
	, Dhall = https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/COMMIT_OR_TAG/package.dhall
}
```

(you should `dhall freeze --inplace dhall/CI.dhall` once you've filled in the relevant commits / tags)

Then, if you're using `dhall-render`, you would use it like so:

# Contents:

This repo contains some core types and functionality which is referenced by multiple components. For templates, helpers and opinionated templates you should also import the various components above.

### Bash:

An overly simple, leaky abstraction for scripts.

This makes no attempt at understanding the syntax or escaping rules for bash, it's really just "a list of lines".

It's not useful for composing expressions, but it _is_ useful for composing commands, conditionals, etc.

It has some opinions, namely that every script shall use `set -eu -o pipefail`. The `renderScript` enforces this, and snippets may not do the right thing if you use them in a script without these settings.

# Workflow:

This module contains the types for generating [github workflow](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions) documents.

It's a minimal wrapping of [regadas/github-actions-dhall](https://github.com/regadas/github-actions-dhall), with the following additions:

 - The toplevel export is the `Workflow` schema, merged with sub-properties for other types (`Job`, `Step`, etc).
 - Addition of the [Env](./Env.dhall), [JobMap](./JobMap.dhall)
 - The [Step](./Step.dhall) contains extra utilities (integration with the [Bash](../Bash/) module, `addEnv`, etc)

# Development workflow

Unfortunately, dhall doesn't make it super easy to "sub in" overrides during development. A pattern I use is:

```
env:DHALL_CI_OVERRIDE ? https://raw.githubusercontent.com/timbertson/dhall-ci/..../package.dhall
```

That evaluates to the dhall-ci package, unless `DHALL_CI_OVERRIDE` is set, in which case that is used as a dhall expression. A relative file (e.g. `export DHALL_CI_OVERRIDE=../dhall-ci/package.dhall`) works well for this.

Unfortunately, the `?` operator is not built for this. It's actually a fallback operator, which means that if your override can't be loaded (fails to typecheck etc), it'll fallback to the public version without warning, which is pretty frustrating.
