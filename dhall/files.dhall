let CI = ./dependencies/CI.dhall

let Prelude = ../dependencies/Prelude.dhall

let Meta = ../Meta/package.dhall

let Dhall = CI.Dhall

let Docker = CI.Docker.Workflow

let Workflow = CI.Workflow

let workflowTestSteps =
    -- a few tests for workflow conditional values
      [     Workflow.Step.bash
              [ "[ \"\$result\" = \"refs/heads/\$GITHUB_HEAD_REF\" ]" ]
        //  { name = Some "Test branchRef (PR)"
            , `if` = Some Workflow.Expr.isPullRequest
            , env = Some
                (toMap { result = Workflow.expr Workflow.Expr.branchRef })
            }
      ,     Workflow.Step.bash [ "[ \"\$result\" = \"\$GITHUB_REF\" ]" ]
        //  { name = Some "Test branchRef (push)"
            , `if` = Some Workflow.Expr.isPushToMain
            , env = Some
                (toMap { result = Workflow.expr Workflow.Expr.branchRef })
            }
      ]

let DhallVersion = { tag : Text, dhall : Text, json : Text, yaml : Text }

let dhallVersion =
      { tag = "1.37", dhall = "1.37.1", json = "1.7.4", yaml = "1.2.4" }

let priorVersions =
        [ { tag = "1.33", dhall = "1.33.1", json = "1.7.0", yaml = "1.2.0" } ]
      : List DhallVersion

let image = Meta.Files.default.ciImage // { tag = Some dhallVersion.dhall }

let publishVerison =
      \(version : DhallVersion) ->
        Docker.Project.steps
          Docker.Project::{
          , image = image // { tag = Some version.tag }
          , build = CI.Docker.Build::{
            , buildArgs =
              [ "DHALL_VERSION=${version.dhall}"
              , "DHALL_JSON_VERSION=${version.json}"
              , "DHALL_YAML_VERSION=${version.yaml}"
              ]
            }
          }

let dockerSteps =
    -- steps to build & publish each version of dhall
        Prelude.List.concat
          Workflow.Step.Type
          ( Prelude.List.map
              DhallVersion
              (List Workflow.Step.Type)
              publishVerison
              ([ dhallVersion ] # priorVersions)
          )
      : List Workflow.Step.Type

in  { files =
        Meta.files
          Meta.Files::{
          , ciScript = Dhall.lint Dhall.Lint::{ file = "Meta/package.dhall" }
          , ciSteps = workflowTestSteps # dockerSteps
          , ciImage = Docker.commitImage image
          , readme = Meta.Readme::{
            , repo = "dhall-ci"
            , componentDesc = None Text
            , parts = [ ./readme-content.md as Text ]
            }
          }
    }
