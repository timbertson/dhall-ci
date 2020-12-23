let embed = \(expr : Text) -> "\${{ ${expr} }}"

let ternaryStr =
    -- Whoo is this a hack. Thanks, https://github.community/t/do-expressions-support-ternary-operators-to-change-their-returned-value/18114
    -- "The condition evaluates to a boolean, which is implicitly cast to a number and used as array index, where false = 0 and true = 1"
      \(condition : Text) ->
      \(ifTrue : Text) ->
      \(ifFalse : Text) ->
        let jsonStr = "format('[\"{0}\",\"{1}\"]', ${ifFalse}, ${ifTrue})"

        let json = "fromJson(${jsonStr})"

        in  "${json}[${condition}]"

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
      ternaryStr
        isPullRequest
        "format('refs/heads/{0}', github.head_ref)"
        "github.ref"

in  { embed, branchRef, isPullRequest, isPush, isPushToMain, ternaryStr }
