{-|

# TODO:

 - freeze external imports

 - versioning workflow
   - use autorelease action
   - use derived-commits
   - cleanup derived branches

-}
let CI = ../dhall/dependencies/CI.dhall

let Prelude = ../dependencies/Prelude.dhall

let Bash = CI.Bash

let Git = CI.Git.Workflow

let Render = CI.Render

let Dhall = CI.Dhall

let Workflow = CI.Workflow

let Docker = CI.Docker.Workflow

let Make = CI.Make

let Readme =
      let Opts =
            { owner : Text
            , repo : Text
            , componentDesc : Optional Text
            , parts : List Text
            }

      let statusBadge =
            \(opts : Opts) ->
            \(workflow : Text) ->
              let img =
                    "![${workflow}](https://github.com/${opts.owner}/${opts.repo}/actions/workflows/${workflow}.yml/badge.svg)"

              let url =
                    "https://github.com/${opts.owner}/${opts.repo}/actions/workflows/${workflow}.yml"

              in  "[${img}](${url})"

      let componentHeader =
            \(opts : Opts) ->
              merge
                { Some =
                    \(desc : Text) ->
                      [ ''
                        # ${opts.repo}

                        This repository provides ${desc} for [dhall-ci](https://github.com/timbertson/dhall-ci),
                        you should go there for more details.
                        ''
                      ]
                , None = [] : List Text
                }
                opts.componentDesc

      let contents =
            \(opts : Opts) ->
              let allParts =
                    Prelude.List.concat
                      Text
                      [ [ statusBadge opts "ci", statusBadge opts "update" ]
                      , componentHeader opts
                      , opts.parts
                      ]

              in  Prelude.Text.concatSep "\n\n" allParts

      in  { Type = Opts
          , default = { owner = "timbertson", parts = [] : List Text }
          , contents
          }

let DhallVersion =
      { tag : Text, dhall : Text, json : Text, yaml : Text, docs : Text }

let dhallVersion =
    -- https://github.com/dhall-lang/dhall-haskell/releases
      { tag = "1.37"
      , dhall = "1.37.1"
      , json = "1.7.4"
      , yaml = "1.2.4"
      , docs = "1.0.3"
      }

let Files =
      { Type =
          { ciScript : Bash.Type
          , ciSteps : List Workflow.Step.Type
          , ciImage : CI.Docker.Image.Type
          , readme : Readme.Type
          , packages : List Text
          , bumpFiles : List Text
          , bumpSpecs : List Text
          }
      , default =
        { ciScript = [] : Bash.Type
        , ciSteps = [] : List Workflow.Step.Type
        , ciImage = CI.Docker.Image::{
          , name =
              "${CI.Docker.Registry.githubPackages}/timbertson/dhall-ci/dhall"
          , tag = Some dhallVersion.tag
          }
        , packages = [ "package.dhall", "dhall/files.dhall" ]
        , bumpFiles = [ "dependencies/CI.dhall", "dhall/Meta.dhall" ]
        , bumpSpecs =
          [ "timbertson/dhall-ci:"
          , "timbertson/dhall-ci-git:"
          , "timbertson/dhall-ci-dhall:"
          , "timbertson/dhall-ci-docker:"
          , "timbertson/dhall-render:"
          ]
        }
      }

let ci =
      \(opts : Files.Type) ->
        CI.Workflow::{
        , name = "CI"
        , on = Workflow.On.pullRequestOrMain
        , jobs = toMap
            { build = Workflow.Job::{
              , runs-on = CI.Workflow.ubuntu
              , steps =
                    [ Git.checkout Git.Checkout::{=}, Docker.loginToGithub ]
                  # opts.ciSteps
                  # [     Workflow.Step.bash
                            ( CI.Docker.runInCwd
                                CI.Docker.Run::{ image = opts.ciImage }
                                ( CI.Git.requireCleanWorkspaceAfterRunning
                                    [ "make ci" ]
                                )
                            )
                      //  { name = Some "Check generated files" }
                    ]
              }
            }
        }

let selfUpdate =
      \(opts : Files.Type) ->
        CI.Workflow::{
        , name = "Self-update"
        , on = Workflow.On::{
          , schedule = Some [ { cron = "0 0 * * 1,4" } ]
          , push = Some Workflow.Push::{ branches = Some [ "wip" ] }
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
                                  { updateScript =
                                      Bash.renderScript
                                        ( CI.Docker.runInCwd
                                            CI.Docker.Run::{
                                            , image = Files.default.ciImage
                                            }
                                            [ "make bump ci" ]
                                        )
                                  , GITHUB_TOKEN = "\${{secrets.GHTOKEN_PAT}}"
                                  }
                              )
                          }
                      //  { name = Some "Self-update" }
                    ]
              }
            }
        }

let files =
      \(opts : Files.Type) ->
            Render.SelfInstall.files Render.SelfInstall::{=}
        //  { Makefile = Render.TextFile::{
              , contents =
                  Make.render
                    Make::{
                    , targets =
                          [ Make.Target.Phony::{
                            , name = "ci"
                            , dependencies = [ "render", "lint" ]
                            , script = opts.ciScript
                            }
                          , Make.Target.Phony::{
                            , name = "digest"
                            , script =
                                Prelude.List.map
                                  Text
                                  Text
                                  ( \(path : Text) ->
                                      "dhall hash --file " ++ path
                                  )
                                  opts.packages
                            }
                          ]
                        # Dhall.Project.makefileTargets
                            Dhall.Project::{
                            , packages = opts.packages
                            , bump = Some Dhall.Project.Bump::{
                              , files = opts.bumpFiles
                              , options = Dhall.Bump::{
                                , specs = opts.bumpSpecs
                                , allowUnused = True
                                , ifAffects = opts.packages
                                , freezeCmd = Some
                                    "dhall --ascii freeze --inplace"
                                }
                              }
                            , docs = Some Dhall.Docs::{=}
                            }
                            Dhall.Project.Makefile::{=}
                    }
              }
            , `.github/workflows/ci.yml` = (Render.YAMLFile Workflow.Type)::{
              , install = Render.Install.Write
              , contents = ci opts
              }
            , `.github/workflows/update.yml` = ( Render.YAMLFile Workflow.Type
                                               )::{
              , install = Render.Install.Write
              , contents = selfUpdate opts
              }
            , `.gitattributes` = Render.TextFile::{
              , install = Render.Install.Write
              , contents =
                  ''
                  generated/** linguist-generated
                  .github/workflows linguist-generated
                  README.md linguist-generated
                  ''
              }
            , `.tool-versions` = Render.TextFile::{
              , contents =
                  ''
                  dhall ${dhallVersion.dhall}
                  ''
              }
            , `README.md` = Render.TextFile::{
              , install = Render.Install.Write
              , headerFormat = Render.Header.html
              , contents = Readme.contents opts.readme
              }
            , LICENCE = Render.TextFile::{
              , install = Render.Install.Write
              , contents =
                  ''
                  Copyright 2020 Tim Cuthbertson

                  Licensed under the Apache License, Version 2.0 (the "License");
                  you may not use this file except in compliance with the License.
                  You may obtain a copy of the License at

                      http://www.apache.org/licenses/LICENSE-2.0

                  Unless required by applicable law or agreed to in writing, software
                  distributed under the License is distributed on an "AS IS" BASIS,
                  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                  See the License for the specific language governing permissions and
                  limitations under the License.
                  ''
              }
            , `.ignore` = Render.TextFile::{
              , contents =
                  ''
                  generated/
                  .github/workflows
                  ''
              }
            }

in  { files, Files, Readme, DhallVersion, dhallVersion }
