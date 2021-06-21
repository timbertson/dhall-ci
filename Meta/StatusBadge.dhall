let Opts = { owner : Text, repo : Text }

let markdown =
      \(opts : Opts) ->
      \(workflow : Text) ->
        let img =
              "![${workflow}](https://github.com/${opts.owner}/${opts.repo}/actions/workflows/${workflow}.yml/badge.svg)"

        let url =
              "https://github.com/${opts.owner}/${opts.repo}/actions/workflows/${workflow}.yml"

        in  "[${img}](${url})"

in  { Type = Opts, default = {=}, markdown }
