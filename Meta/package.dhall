let CI = ../dhall/dependencies/CI.dhall

let Bash = CI.Bash

let Render = CI.Render

let Dhall = CI.Dhall

let Files = { Type = { ciExtra : Bash.Type }, default.ciExtra = [] : Bash.Type }

let files =
      \(opts : Files.Type) ->
            Render.SelfInstall.files Render.SelfInstall::{=}
        //  { dhall/ci = Render.Executable::{
              , contents =
                  Bash.renderScript
                    ( Bash.join
                        [ Dhall.lint Dhall.Lint::{ file = "package.dhall" }
                        , Dhall.lint Dhall.Lint::{ file = "dhall/files.dhall" }
                        , Dhall.render Dhall.Render::{=}
                        , opts.ciExtra
                        ]
                    )
              }
            , `.gitattributes` = Render.TextFile::{
              , install = Render.Install.Write
              , contents =
                  ''
                  generated/** linguist-generated
                  .github/workflows linguist-generated
                  ''
              }
            }

in  { files, Files }
