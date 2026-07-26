#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{LazyLock, OnceLock};

// small value: `const` — inlined at each use, no address needed
const MAX_RETRIES: u32 = 3;
const TIMEOUT_MS: u64 = 5_000;
const FLAG_MASK: u8 = 0b0000_1111;

// large data: `static` — one copy in the binary, shareable as `&'static`
static LOOKUP: [u8; 256] = [0u8; 256];

fn process(byte: u8) -> u8 {
    LOOKUP[byte as usize]
}

// `&'static str` requires a `static` (or a string literal)
static APP_NAME: &str = "my-app";

// mutable global state — use atomics, not `static mut`
static REQUEST_COUNT: AtomicU64 = AtomicU64::new(0);

fn record_request() {
    REQUEST_COUNT.fetch_add(1, Ordering::Relaxed);
}

// lazily initialized global — `LazyLock` (stable since 1.80)
static CONFIG_PATH: LazyLock<String> = LazyLock::new(|| {
    std::env::var("CONFIG_PATH").unwrap_or_else(|_| "/etc/app/config.toml".to_owned())
});

// single-assignment global — `OnceLock`
static GREETING: OnceLock<String> = OnceLock::new();

fn set_greeting(name: &str) {
    let _ = GREETING.set(format!("hello, {name}"));
}
;
Ok(())
}
fn main() {}
