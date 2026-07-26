#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// using trait-variant to get both a static and a dyn-compatible variant
#[trait_variant::make(RepoSend: Send)]
trait Repo {
    async fn get(&self, id: u64) -> anyhow::Result<String>;
}

// `RepoSend` is the Send-bounded version; it IS dyn-compatible via boxing
fn make_repo() -> Box<dyn RepoSend> {
    // ...
    # unimplemented!()
}
;
Ok(())
}
fn main() {}
