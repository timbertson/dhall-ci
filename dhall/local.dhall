-- used with ./local heler script to set environment variables,
-- which are used (if present) by ./files.dhall
toMap {
  , DHALL_LOCAL_CI = ./dependencies/CI.dhall.local as Location
}

