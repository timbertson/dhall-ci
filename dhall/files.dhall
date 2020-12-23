let CI = ./dependencies/CI.dhall

let Meta = ../Meta/package.dhall

let Dhall = CI.Dhall

let Docker = CI.Docker.Workflow

let Workflow = CI.Workflow

let dhallVersion = { dhall = "1.37.1", json = "1.7.4", yaml = "1.2.4" }

let image = Meta.Files.default.ciImage

let workflowTestSteps =
    -- a few tests for workflow conditional values
      [     Workflow.Step.bash
              [ "[ \"\$result\" = \"refs/heads/\$GITHUB_HEAD_REF\" ]" ]
        //  { name = Some "Test branchRef (PR)"
            , `if` = Some Workflow.Expr.isPullRequest
            , env = Some
                (toMap { result = Workflow.Expr.embed Workflow.Expr.branchRef })
            }
      ,     Workflow.Step.bash [ "[ \"\$result\" = \"\$GITHUB_REF\" ]" ]
        //  { name = Some "Test branchRef (push)"
            , `if` = Some Workflow.Expr.isPushToMain
            , env = Some
                (toMap { result = Workflow.Expr.embed Workflow.Expr.branchRef })
            }
      ]

let dockerSteps =
    -- TODO: publish multiple dhall versions
        Docker.Project.steps
          Docker.Project::{
          , image
          , build = CI.Docker.Build::{
            , buildArgs =
              [ "DHALL_VERSION=${dhallVersion.dhall}"
              , "DHALL_JSON_VERSION=${dhallVersion.json}"
              , "DHALL_YAML_VERSION=${dhallVersion.yaml}"
              ]
            }
          }
      : List CI.Workflow.Step.Type

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
