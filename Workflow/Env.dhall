let Prelude = ../Dependencies/Prelude.dhall

let Env = Prelude.Map.Type Text Text

let expression = \(expr : Text) -> "\${{ ${expr} }}"

in  { Type = Env, empty = [] : Env, expression }
