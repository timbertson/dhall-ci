{-|
This module does not define a strong type for bash scripts, it's really just used to support linewise operations (like indenting)
-}
let Prelude = ../dependencies/Prelude.dhall

let concatSep = Prelude.Text.concatSep

let Bash = List Text

let render = concatSep "\n" : Bash -> Text

let join = Prelude.List.concat Text : List Bash -> Bash

let map = Prelude.List.map Text Text

let indent = map (\(line : Text) -> "  " ++ line) : Bash -> Bash

let strictFlags = "-eu -o pipefail"

let strict = [ "set ${strictFlags}" ] : Bash

let trace = [ "set -x" ] : Bash

let shebang = [ "#!/usr/bin/env bash" ]

let prelude = shebang # strict : Bash

let renderScript
    : Bash -> Text
    = \(parts : List Text) -> render (join [ prelude, parts ]) ++ "\n"

let doubleQuote
                -- NOTE this performs no escaping, it simply wraps the text in double quotes
                =
      \(arg : Text) -> "\"${arg}\""

let doubleQuoteArgs
                    -- NOTE this perform no escaping, it simply wraps each argument in double quotes
                    =
      \(args : List Text) ->
        concatSep " " (Prelude.List.map Text Text doubleQuote args)

let `if` =
      \(test : Text) ->
      \(body : Bash) ->
        join [ [ "if ${test}; then" ], indent body, [ "fi" ] ]

let ifElse =
      \(test : Text) ->
      \(body : Bash) ->
      \(elseBody : Bash) ->
        join
          [ [ "if ${test}; then" ]
          , indent body
          , [ "else" ]
          , indent elseBody
          , [ "fi" ]
          ]

in  { Type = Bash
    , prelude
    , strict
    , strictFlags
    , trace
    , renderScript
    , doubleQuote
    , doubleQuoteArgs
    , indent
    , `if`
    , ifElse
    , join
    , render
    }
