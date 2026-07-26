#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::watch;

let (tx, rx) = watch::channel(Config::default());

// Multiple observers
let rx1 = rx.clone();
let rx2 = rx.clone();

// Observer 1: waits for changes
tokio::spawn(async move {
    let mut rx = rx1;
    while rx.changed().await.is_ok() {
        let config = rx.borrow();
        apply_config(&*config);
    }
});

// Observer 2: also sees all changes
tokio::spawn(async move {
    let mut rx = rx2;
    while rx.changed().await.is_ok() {
        let config = rx.borrow();
        log_config_change(&*config);
    }
});

// Update the value
tx.send(Config::new())?;
;
Ok(())
}
fn main() {}
