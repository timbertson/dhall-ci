let embed = \(expr : Text) -> "\${{ ${expr} }}"

let fallbackTernary =
    -- An approximation of a ternary operator, except it requires that `ifTrue`
    -- is itself truthy when the condition is truthy
      \(condition : Text) ->
      \(ifTrue : Text) ->
      \(ifFalse : Text) ->
        "(${condition} && ${ifTrue}) || ${ifFalse}"

let isPullRequest = "github.event_name == 'pull_request'"

let isPush = "github.event_name == 'push'"

let isPushToMain =
    -- (or master)
      "${isPush} && (github.ref == 'refs/heads/master' || github.ref == 'refs/heads/master')"

let branchRef =
    -- GH expressions strangely lack a builtin for this.
    -- `github.head_ref` is the branch name, only defined for a PR
    -- But for a push, we get `github.ref` but that contains the leading 'refs/heads/'
    -- Ideally we'd return the branch name without `refs/heads`, but there's no replace operator
    -- so for consistency we always return `refs/heads/*`
      fallbackTernary
        isPullRequest
        "format('refs/heads/{0}', github.head_ref)"
        "github.ref"

in  { embed, branchRef, isPullRequest, isPush, isPushToMain }
