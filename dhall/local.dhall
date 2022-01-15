-- used with ./local heler script to set environment variables,
-- which are used (if present) by ./files.dhall

-- DHALL_CI and DHALL_CI_META are provided do that dependent projects
-- can use them, they're not used in this project
toMap {
, DHALL_CI= ./../package.dhall as Location
, DHALL_CI_META= ../Meta/package.dhall as Location
, DHALL_CI_GIT= ../../dhall-ci-git/package.dhall as Location
, DHALL_CI_DOCKER= ../../dhall-ci-docker/package.dhall as Location
, DHALL_CI_DHALL= ../../dhall-ci-dhall/package.dhall as Location
, DHALL_RENDER= ../../dhall-render/package.dhall as Location
}
