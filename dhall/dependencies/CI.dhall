-- merge dhall-ci (self) modules with external ones
    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/e4e2cb45bdaa7bf2d4f6054feaf814fd1d6986b1/package.dhall
            sha256:f8071927cf5f6ae54968ee72806efa4b2efb9cbd1916fb46d3c1c1816465ea52
    , Docker =
          env:DHALL_CI_DOCKER
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/c37161f9ef8170479b11a8535ad48b7eb0b00700/package.dhall
            sha256:40a5bf20c9e23622834e8d83686515b03af047a63bbda8c114c1affcae3b7708
    , Dhall =
          env:DHALL_CI_DHALL
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/3206481d4e9b7510184a089996c8a953e6218eab/package.dhall
            sha256:9c032dd7d5ff168b1cc25eda52a716b6cfee98d7a08380ac349a1161c7b5a7f3
    , Render =
          env:DHALL_RENDER
        ? https://raw.githubusercontent.com/timbertson/dhall-render/9d7cc16ddcdc150376f6bdbec2120dff3f913be1/package.dhall
            sha256:23bf76eacc77e7ef2387b4dc574e8735e0811d7b8b1c7e268823ae03c9e001dd
    }
