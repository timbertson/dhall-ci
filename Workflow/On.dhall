let Workflow = ../dependencies/Workflow.dhall

let pullRequestOrBranches =
      \(branches : List Text) ->
        Workflow.On::{
        , pull_request = Some Workflow.PullRequest::{=}
        , push = Some Workflow.Push::{ branches = Some branches }
        }

let mainBranches = [ "master", "main" ]

let pullRequestOrMain = pullRequestOrBranches mainBranches

let pullRequestOrReleaseBranches =
      pullRequestOrBranches (mainBranches # [ "v*.x*" ])

in  { pullRequestOrBranches, pullRequestOrMain, pullRequestOrReleaseBranches }
