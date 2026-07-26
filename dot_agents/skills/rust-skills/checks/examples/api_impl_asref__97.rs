#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// AsRef<T>: cheap borrow, no ownership transfer
fn read(p: impl AsRef<Path>) {
    let path: &Path = p.as_ref();
}

// Into<T>: ownership transfer, may allocate
fn store(p: impl Into<PathBuf>) {
    let owned: PathBuf = p.into();
}

// Borrow<T>: like AsRef but with Eq/Hash consistency guarantee
use std::borrow::Borrow;
fn lookup<Q: ?Sized>(map: &HashMap<String, V>, key: &Q) -> Option<&V>
where
    String: Borrow<Q>,
    Q: Hash + Eq,
{
    map.get(key)
}
;
Ok(())
}
fn main() {}
