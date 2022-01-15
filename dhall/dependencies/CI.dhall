-- merge dhall-ci (self) modules with external ones
    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/653bfcf56e32d648539dc5cfc74676b051cc6827/package.dhall
            sha256:f8071927cf5f6ae54968ee72806efa4b2efb9cbd1916fb46d3c1c1816465ea52
    , Docker =
          env:DHALL_CI_DOCKER
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/cddaef0e5eb75aadc6e4b32c20ad9aaff1fa6945/package.dhall
            sha256:7ae8c880d6e35d2ef1d7ea7b34cb98fb0dc175c2323bcc6863a9e04067f5a39c
    , Dhall =
          env:DHALL_CI_DHALL
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/d0782293dba69fcefa8cee4b5890a5e0d2ddc181/package.dhall
            sha256:9c032dd7d5ff168b1cc25eda52a716b6cfee98d7a08380ac349a1161c7b5a7f3
    , Render =
          env:DHALL_RENDER
        ? https://raw.githubusercontent.com/timbertson/dhall-render/5e2290a641c166c11d5eafb1eadb2a5bd5e83a01/package.dhall
            sha256:f0d8ee37958b7e4647005c446bd17ff4817797750381a2dd9c9c580984c9a69f
    }
