let Base = ../dependencies/Workflow.dhall

in      Base
    /\  Base.Workflow
    /\  { Env = ./Env.dhall
        , expr = \(expr : Text) -> "\${{ ${expr} }}"
        , Expr = ./Expr.dhall
        , On = ./On.dhall
        , JobMap = ./JobMap.dhall
        , Step = ./Step.dhall
        , ubuntu = Base.RunsOn.Type.ubuntu-latest
        }
