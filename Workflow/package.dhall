let Base = ../dependencies/Workflow.dhall

in      (Base /\ Base.Workflow)
    //  { Env = ./Env.dhall
        , JobMap = ./JobMap.dhall
        , Step = ./Step.dhall
        , ubuntu = Base.RunsOn.Type.ubuntu-latest
        }
