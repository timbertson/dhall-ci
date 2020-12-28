    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/5d17b9deb2f6d60d7371a6abab19da8ede1ce781/package.dhall sha256:d771fc8a26226b3b8290a51bb7bb9b41986f187ee051094209ca0250396cef41
    , Docker =
          env:DHALL_CI_DOCKER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/50e3724a71071f00ced1f40b591021f47910710c/package.dhall sha256:2cf44cb0969f10539315445967c347a1cb4ace661080361ea669a405da422d1d
    , Dhall =
          env:DHALL_CI_DHALL_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/29dce9980cf9d4eeef9eee8f28b852aaa8d1a7ad/package.dhall sha256:c9c3b9d77f9bef54ff723e16723c17f93b979895978b94bd8636ff6869c089ae
    , Render =
        https://raw.githubusercontent.com/timbertson/dhall-render/0ab56814a963f93d240c95eaea38cd0875b69857/package.dhall sha256:7d75a0fe2c4b1450f6f9ad54fe1e89de618281ddda9dc2cedb53c36ee17ad4cd
    }
