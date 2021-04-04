let Prelude = ../dependencies/Prelude.dhall

let Lines = List Text

let joinWith
    : Text -> List Lines -> Text
    = \(sep : Text) ->
      \(parts : List Lines) ->
        let textParts =
              Prelude.List.map Lines Text (Prelude.Text.concatSep "\n") parts

        in  Prelude.Text.concatSep sep textParts

let join
    : List Lines -> Text
    = joinWith "\n"

in  { Type = Lines, join, joinWith }
