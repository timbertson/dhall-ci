let CI = ../dhall/dependencies/CI.dhall

let Bash = CI.Bash

let Git = CI.Git.Workflow

let Workflow = CI.Workflow

let Docker = CI.Docker.Workflow

let Opts =
      { dhallImage : CI.Docker.Image.Type
      , bump : CI.Bash.Type
      , render : CI.Bash.Type
      }

let default = {=}

let workflow =
      \(opts : Opts) ->
        CI.Workflow::{
        , name = "Update"
        , on = Workflow.On::{
          , schedule = Some [ { cron = "0 0 * * 1,4" } ]
          , push = Some Workflow.Push::{ branches = Some [ "self-upate-test" ] }
          , workflow_dispatch = Some Workflow.WorkflowDispatch.default
          }
        , jobs = toMap
            { update = Workflow.Job::{
              , runs-on = CI.Workflow.ubuntu
              , steps =
                    [ Git.checkout Git.Checkout::{=}, Docker.loginToGithub ]
                  # [     Workflow.Step::{
                          , uses = Some "timbertson/self-update-action@v1"
                          , `with` = Some
                              ( toMap
                                  { setupScript =
                                      Bash.renderScript
                                        ( CI.Docker.runInCwd
                                            CI.Docker.Run::{
                                            , image = opts.dhallImage
                                            }
                                            opts.bump
                                        )
                                  , updateScript =
                                      Bash.renderScript
                                        ( CI.Docker.runInCwd
                                            CI.Docker.Run::{
                                            , image = opts.dhallImage
                                            }
                                            opts.render
                                        )
                                  , GITHUB_TOKEN = "\${{secrets.GHTOKEN_PAT}}"
                                  }
                              )
                          }
                      //  { name = Some "self-update" }
                    ]
              }
            }
        }

in  { Type = Opts, default, workflow }
