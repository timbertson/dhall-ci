let Render =
      https://raw.githubusercontent.com/timbertson/dhall-render/85535415e37bf0907fc71df7994b57553e2c45d0/package.dhall sha256:4da0c7fe4db64c18ee928efe0395e0bb6d7b9db41839dfeb44d3964ae00269cb

in  { files =
            Render.SelfInstall.files Render.SelfInstall::{=}
        //  {=}
    }
