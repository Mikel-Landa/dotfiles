#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// https://github.com/BurntSushi/ripgrep/blob/master/crates/globset/src/pathutil.rs
pub(crate) fn file_name<'a>(path: &Cow<'a, [u8]>) -> Option<Cow<'a, [u8]>> {
    match *path {
        Cow::Borrowed(path) => Cow::Borrowed(&path[last_slash..]),
        Cow::Owned(ref path) => Cow::Owned(path.clone()),
    }
}
;
Ok(())
}
fn main() {}
