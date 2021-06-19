let CI = ./dependencies/CI.dhall

let Render = CI.Render

in  { files =
            Render.SelfInstall.files Render.SelfInstall::{=}
        /\  { hello = Render.TextFile::{ contents = "world!" } }
    }
