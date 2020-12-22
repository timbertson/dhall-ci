{-
TODO:

 - LICENCE
 - README.md as components, with defaults:
   - header for component repos
   - CI actions badge

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
