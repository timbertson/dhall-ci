let Base = ../Dependencies/Workflow.dhall

in      (Base /\ Base.Workflow)
    //  { Env = ./Env.dhall, JobMap = ./JobMap.dhall, Step = ./Step.dhall }
