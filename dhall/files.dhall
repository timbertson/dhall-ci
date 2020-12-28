let CI = ./dependencies/CI.dhall

let Prelude = ../dependencies/Prelude.dhall

let Meta = ../Meta/package.dhall

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

let priorVersions = [] : List Meta.DhallVersion

let image = Meta.Files.default.ciImage

let publishVerison =
      \(version : Meta.DhallVersion) ->
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
              Meta.DhallVersion
              (List Workflow.Step.Type)
              publishVerison
              ([ Meta.dhallVersion ] # priorVersions)
          )
      : List Workflow.Step.Type

in  { files =
        Meta.files
          Meta.Files::{
          , packages = Meta.Files.default.packages # [ "Meta/package.dhall" ]
          , bumpFiles =
              [ "dependencies/Workflow.dhall", "dhall/dependencies/CI.dhall" ]
          , ciSteps = workflowTestSteps # dockerSteps
          , ciImage = Docker.commitImage image
          , bump = Dhall.Bump::{=}
          , readme = Meta.Readme::{
            , repo = "dhall-ci"
            , componentDesc = None Text
            , parts = [ ./readme-content.md as Text ]
            }
          }
    }
