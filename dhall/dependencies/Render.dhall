-- applications should use a separate CI / Render file,
-- but dhall-ci modules currently use a single combined CI.dhall
-- (for ease of batch-updating components). This alias is just
-- so that bootstrap-files evaluates
(./CI.dhall).Render