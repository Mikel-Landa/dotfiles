#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Config {
    debug: bool,
    timeout: Option<u64>,
}

fn effective_timeout(cfg: &Config) -> Option<u64> {
    if cfg.debug
        && let Some(t) = cfg.timeout
        && t > 0
    {
        Some(t)
    } else {
        None
    }
}
;
Ok(())
}
fn main() {}
