let Render = ./dependencies/Render.dhall

let CI = ./dependencies/CI.dhall

let Bash = CI.Bash

let Dhall = CI.Dhall
let Docker = CI.Docker.Workflow

let Git = CI.Git.Workflow
let Workflow = CI.Workflow


let dhallVersion = { dhall = "1.33.0", json = "1.7.0", yaml = "1.2.0" }

let image =
      CI.Docker.Image::{
      , name = "${CI.Docker.Registry.github}/timbertson/dhall-ci"
      }

let ci =
    -- TODO: publish multiple dhall versions
      CI.Workflow::{
      , name = "CI"
      , on = Git.pullRequestOrMain
      , jobs = toMap
          { build = Workflow.Job::{
            , runs-on = CI.Workflow.ubuntu
            , steps =
                  [ Git.checkout Git.Checkout::{=} : CI.Workflow.Step.Type ]
                # (   Docker.Project.steps
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
                  )
                # [
                  (Workflow.Step.bash (
                    CI.Docker.runInCwd CI.Docker.Run::{
                      , image = Docker.commitImage image
                    }
                    (CI.Git.requireCleanWorkspaceAfterRunning ["./dhall/ci"])
                  )) // { name = Some "Check generated files" }
                ]
            }
          }
      }

in  { files =
            Render.SelfInstall.files Render.SelfInstall::{=}
        //  { `.github/workflow/docker.yml` = (Render.YAMLFile Workflow.Type)::{
              , install = Render.Install.Write
              , contents = ci
              }
            , `dhall/ci` = Render.Executable::{
                contents = Bash.renderScript (Bash.join
                [
                  , Dhall.lint Dhall.Lint::{file = "package.dhall"}
                  , Dhall.render Dhall.Render::{=}
                ])
              }
            }
    }
