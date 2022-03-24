-- merge dhall-ci (self) modules with external ones
    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/e4e2cb45bdaa7bf2d4f6054feaf814fd1d6986b1/package.dhall
            sha256:f8071927cf5f6ae54968ee72806efa4b2efb9cbd1916fb46d3c1c1816465ea52
    , Docker =
          env:DHALL_CI_DOCKER
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/20f24dc02808fb80add0799d1cab742b796fba2a/package.dhall
            sha256:7ae8c880d6e35d2ef1d7ea7b34cb98fb0dc175c2323bcc6863a9e04067f5a39c
    , Dhall =
          env:DHALL_CI_DHALL
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/3206481d4e9b7510184a089996c8a953e6218eab/package.dhall
            sha256:9c032dd7d5ff168b1cc25eda52a716b6cfee98d7a08380ac349a1161c7b5a7f3
    , Render =
          env:DHALL_RENDER
        ? https://raw.githubusercontent.com/timbertson/dhall-render/9d7cc16ddcdc150376f6bdbec2120dff3f913be1/package.dhall
            sha256:23bf76eacc77e7ef2387b4dc574e8735e0811d7b8b1c7e268823ae03c9e001dd
    }
