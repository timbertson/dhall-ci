let Env = List { mapKey : Text, mapValue : Text }

let githubToken = toMap { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }

in  { Type = Env, empty = [] : Env, githubToken }
