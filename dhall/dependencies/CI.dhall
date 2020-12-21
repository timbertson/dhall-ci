    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/master/package.dhall
    , Docker =
          env:DHALL_CI_DOCKER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/master/package.dhall
    }
