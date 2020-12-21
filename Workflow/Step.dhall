let Bash = ../Bash/package.dhall

let Env = ./Env.dhall

let Base = ../dependencies/Workflow.dhall

let Step = Base.Step.Type

let addToMap =
      \(addition : Env.Type) ->
      \(existing : Optional Env.Type) ->
        Some
          ( merge
              { None = addition
              , Some = \(existing : Env.Type) -> existing # addition
              }
              existing
          )

let addEnv =
      \(env : Env.Type) ->
      \(step : Step) ->
        step // { env = addToMap env step.env } : Step

let addParams =
      \(params : Env.Type) ->
      \(step : Step) ->
        step // { `with` = addToMap params step.`with` } : Step

let bash =
      \(bash : Bash.Type) ->
        Base.Step::{
        , run = Some (Bash.render (Bash.strict # Bash.trace # bash))
        }

in  { Type = Step
    , default = Base.Step.default
    , addEnv
    , addParams
    , bash
    , cmd = \(cmd : Text) -> bash [ cmd ]
    }
