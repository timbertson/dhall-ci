let CI = ./dependencies/CI.dhall

let Render = ./dependencies/Render.dhall

in  { files =
            Render.SelfInstall.files Render.SelfInstall::{=}
        /\  { hello = Render.TextFile::{ contents = "world!" } }
    }
