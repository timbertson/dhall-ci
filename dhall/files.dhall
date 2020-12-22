let CI = ./dependencies/CI.dhall

let Meta = ../Meta/package.dhall

let Dhall = CI.Dhall

let Docker = CI.Docker.Workflow

let dhallVersion = { dhall = "1.37.1", json = "1.7.4", yaml = "1.2.4" }

let image = Meta.Files.default.ciImage

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
          , ciSteps = dockerSteps
          , ciImage = Docker.commitImage image
          , readme = Meta.Readme::{
            , repo = "dhall-ci"
            , componentDesc = None Text
            , parts = [ ./readme-content.md as Text ]
            }
          }
    }
