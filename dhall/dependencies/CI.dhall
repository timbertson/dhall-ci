    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/5d17b9deb2f6d60d7371a6abab19da8ede1ce781/package.dhall sha256:d771fc8a26226b3b8290a51bb7bb9b41986f187ee051094209ca0250396cef41
    , Docker =
          env:DHALL_CI_DOCKER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/50e3724a71071f00ced1f40b591021f47910710c/package.dhall sha256:2cf44cb0969f10539315445967c347a1cb4ace661080361ea669a405da422d1d
    , Dhall =
          env:DHALL_CI_DHALL_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/9e8efa51ee072f835eee2f14421a28450bc98b3f/package.dhall sha256:3ef0f7b6280202bab82a6e81ba04c979db839bcdd5d5eaccb22efd35ac698b0b
    , Render =
          env:DHALL_RENDER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-render/495ed147632df53f4794b5420fdaa8e177dd8932/package.dhall sha256:739c7190ac77e5ceb89a5a515445cc29362bfa64f2c793538d6061922ac48232
    }
