let isPush = "github.event_name == 'push'"

let isPullRequest = "github.event_name == 'pull_request'"

in  { isPush
    , isPullRequest
    , isPushToMain =
        -- (or master)
        "${isPush} && (github.ref == 'refs/heads/master' || github.ref == 'refs/heads/master')"
    , branchRef =
        -- GH expressions strangely lack a builtin for this.
        -- `github.head_ref` is the branch name, only defined for a PR
        -- But for a push, we get `github.ref` but that contains the leading 'refs/heads/'
        -- Ideally we'd return the branch name without `refs/heads`, but there's no replace operator
        -- so for consistency we always return `refs/heads/*`
        "(${isPullRequest} && format('refs/heads/{0}', github.head_ref)) || github.ref"
    }
