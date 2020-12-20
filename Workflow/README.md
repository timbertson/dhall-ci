# Github actions Workflows

This module contains the types for generating [github workflow](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions) documents.

It's a minimal wrapping of [regadas/github-actions-dhall](https://github.com/regadas/github-actions-dhall).

Additions to the upstream project:

 - The toplevel export is the `Workflow` schema, merged with sub-properties for other types (`Job`, `Step`, etc).
 - Addition of the [Env](./Env.dhall), [JobMap](./JobMap.dhall)
 - The [Step](./Step.dhall) contains extra utilities (integration with the [Bash](../Bash/) module, `addEnv`, etc)

See the [Template](./Template/) directory for some example usage.
