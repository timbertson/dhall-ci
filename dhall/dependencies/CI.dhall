-- merge dhall-ci (self) modules with external ones
    ../../package.dhall
/\  (   env:DHALL_LOCAL_CI
      ? { Git =
            https://raw.githubusercontent.com/timbertson/dhall-ci-git/653bfcf56e32d648539dc5cfc74676b051cc6827/package.dhall
              sha256:f8071927cf5f6ae54968ee72806efa4b2efb9cbd1916fb46d3c1c1816465ea52
        , Docker =
            https://raw.githubusercontent.com/timbertson/dhall-ci-docker/cddaef0e5eb75aadc6e4b32c20ad9aaff1fa6945/package.dhall
              sha256:7ae8c880d6e35d2ef1d7ea7b34cb98fb0dc175c2323bcc6863a9e04067f5a39c
        , Dhall =
            https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/d0782293dba69fcefa8cee4b5890a5e0d2ddc181/package.dhall
              sha256:9c032dd7d5ff168b1cc25eda52a716b6cfee98d7a08380ac349a1161c7b5a7f3
        , Render =
            https://raw.githubusercontent.com/timbertson/dhall-render/34befa0818f2f8205e1184cec3c3ce3b4b9e46dc/package.dhall
              sha256:5722af993090855bc686d37580b1141266f507c0770d7083e50e899e7cd95e8e
        }
    )
