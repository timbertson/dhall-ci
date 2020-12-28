    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/5d17b9deb2f6d60d7371a6abab19da8ede1ce781/package.dhall sha256:d771fc8a26226b3b8290a51bb7bb9b41986f187ee051094209ca0250396cef41
    , Docker =
          env:DHALL_CI_DOCKER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/50e3724a71071f00ced1f40b591021f47910710c/package.dhall sha256:2cf44cb0969f10539315445967c347a1cb4ace661080361ea669a405da422d1d
    , Dhall =
          env:DHALL_CI_DHALL_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/021420439f9ae72b5b972bd9819b64c69dcc5127/package.dhall sha256:d521fbe763c30d36a4207998bc98dd89ba01163126bd51285fdbe4445935fddc
    , Render =
        https://raw.githubusercontent.com/timbertson/dhall-render/0ab56814a963f93d240c95eaea38cd0875b69857/package.dhall sha256:7d75a0fe2c4b1450f6f9ad54fe1e89de618281ddda9dc2cedb53c36ee17ad4cd
    }
