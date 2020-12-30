    ../../package.dhall
/\  { Git =
          env:DHALL_CI_GIT_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-git/5d17b9deb2f6d60d7371a6abab19da8ede1ce781/package.dhall sha256:d771fc8a26226b3b8290a51bb7bb9b41986f187ee051094209ca0250396cef41
    , Docker =
          env:DHALL_CI_DOCKER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-docker/50e3724a71071f00ced1f40b591021f47910710c/package.dhall sha256:2cf44cb0969f10539315445967c347a1cb4ace661080361ea669a405da422d1d
    , Dhall =
          env:DHALL_CI_DHALL_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-ci-dhall/a4ebf288a0ffabfca38ef962dc1403c9de9f2437/package.dhall sha256:7684592263ff1415a34358ffb9b24568450e1ec7dfdc077e1d2ca6c4152cd04e
    , Render =
          env:DHALL_RENDER_OVERRIDE
        ? https://raw.githubusercontent.com/timbertson/dhall-render/8dc1d0e1cbc5acbe01d8d27e2319f69fdbf438f0/package.dhall sha256:b0545d4b0ee773729933a14290d29a0f654eb1681c9825c5a8a72835d24330e0
    }
