<img src="http://gfxmonk.net/dist/status/project/dhall-ci.png">

# :warning: this project is inactive; see [chored](https://github.com/timbertson/chored) instead

----

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
