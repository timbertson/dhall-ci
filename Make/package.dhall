let Bash = ../Bash/package.dhall

let Prelude = ../dependencies/Prelude.dhall

let Target =
      { Type =
          { name : Text
          , dependencies : List Text
          , script : Bash.Type
          , phony : Bool
          }
      , default =
        { phony = False
        , dependencies = [] : List Text
        , script = [] : Bash.Type
        }
      }

let renderTarget =
      \(target : Target.Type) ->
        let depStr =
              Prelude.Text.concat
                ( Prelude.List.map
                    Text
                    Text
                    (\(target : Text) -> " ${target}")
                    target.dependencies
                )

        let phonyPrefix =
              if    target.phony
              then  ''
                    .PHONY: ${target.name}
                    ''
              else  ""

        let scriptStr =
              Text/replace
                "\n"
                ''

                ${"\t"}''
                (Bash.render target.script)

        in  ''
            ${phonyPrefix}${target.name}:${depStr}
            	${scriptStr}''

let Target =
          Target
      /\  { Phony = Target with default.phony = True, render = renderTarget }

let Makefile =
      { Type = { targets : List Target.Type }
      , default.targets = [] : List Target.Type
      }

let render =
      \(file : Makefile.Type) ->
            Prelude.Text.concatSep
              "\n\n"
              (Prelude.List.map Target.Type Text renderTarget file.targets)
        ++  "\n"

let _testRender =
        assert
      :     render
              Makefile::{
              , targets =
                [ Target::{
                  , name = "bin"
                  , dependencies = [ "src/file1", "src/file2" ]
                  , script =
                    [ ''
                      mkdir -p bin
                      true''
                    , "false"
                    ]
                  }
                , Target.Phony::{ name = "lint", script = [ "dhall lint" ] }
                ]
              }
        ===  ''
             bin: src/file1 src/file2
             	mkdir -p bin
             	true
             	false

             .PHONY: lint
             lint:
             	dhall lint
             ''

let Makefile = Makefile /\ { render }

in  Makefile /\ { Target }
