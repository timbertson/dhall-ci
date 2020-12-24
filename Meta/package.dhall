{-
TODO:

 - LICENCE
 - README.md as components, with defaults:
   - header for component repos
   - CI actions badge

 - freeze external imports

 - auto-update workflow
   - could get tricky. For library dependencies, we want to bump them if the (semantic)
     hash of the import changes. But for dhall/files dependencies, we should only
     bother with an update if it alters the result of `./dhall/ci`

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

let Readme =
      let Opts =
            { owner : Text
            , repo : Text
            , componentDesc : Optional Text
            , parts : List Text
            }

      let statusBadge =
            \(opts : Opts) ->
              let img =
                    "![CI](https://github.com/${opts.owner}/${opts.repo}/workflows/CI/badge.svg)"

              let url =
                    "https://github.com/${opts.owner}/${opts.repo}/actions?query=workflow%3ACI+branch%3Amaster"

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
                      [ [ statusBadge opts ], componentHeader opts, opts.parts ]

              in  Prelude.Text.concatSep "\n\n" allParts

      in  { Type = Opts
          , default = { owner = "timbertson", parts = [] : List Text }
          , contents
          }

let Files =
      { Type =
          { ciScript : Bash.Type
          , ciSteps : List Workflow.Step.Type
          , ciImage : CI.Docker.Image.Type
          , readme : Readme.Type
          }
      , default =
        { ciScript = [] : Bash.Type
        , ciSteps = [] : List Workflow.Step.Type
        , ciImage = CI.Docker.Image::{
          , name =
              "${CI.Docker.Registry.githubPackages}/timbertson/dhall-ci/dhall"
          }
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
                    [ Git.checkout Git.Checkout::{=} : CI.Workflow.Step.Type
                    , Docker.loginToGithub
                    ]
                  # opts.ciSteps
                  # [     Workflow.Step.bash
                            ( CI.Docker.runInCwd
                                CI.Docker.Run::{ image = opts.ciImage }
                                ( CI.Git.requireCleanWorkspaceAfterRunning
                                    [ "dhall/ci" ]
                                )
                            )
                      //  { name = Some "Check generated files" }
                    ]
              }
            }
        }

let files =
      \(opts : Files.Type) ->
            Render.SelfInstall.files Render.SelfInstall::{=}
        //  { dhall/ci = Render.Executable::{
              , contents =
                  Bash.renderScript
                    ( Bash.join
                        [ Dhall.evaluateAndLint
                            Dhall.Lint::{ file = "package.dhall" }
                        , Dhall.lint Dhall.Lint::{ file = "dhall/files.dhall" }
                        , Dhall.render Dhall.Render::{=}
                        , opts.ciScript
                        ]
                    )
              }
            , `.github/workflows/ci.yml` = (Render.YAMLFile Workflow.Type)::{
              , install = Render.Install.Write
              , contents = ci opts
              }
            , `.gitattributes` = Render.TextFile::{
              , install = Render.Install.Write
              , contents =
                  ''
                  generated/** linguist-generated
                  .github/workflows linguist-generated
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

in  { files, Files, Readme }
