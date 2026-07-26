#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct Config {
    threshold: i32,
    label: String,
}

fn demo_good() {
    let config = Config { threshold: 10, label: String::from("active") };

    // Edition 2021: the closure captures only `config.threshold` (a Copy field).
    // `config.label` is NOT captured, so it remains accessible.
    let check = || config.threshold > 0;

    // Both are usable simultaneously.
    println!("label: {}", config.label);  // fine — not captured by `check`
    assert!(check());
}

// When you need `move` for one field, bind it first.
fn make_checker(config: Config) -> (impl Fn() -> bool, String) {
    // Bind the field to a local, then move only that local into the closure.
    let threshold = config.threshold;
    let checker = move || threshold > 0; // moves `threshold` (i32, Copy), not `config`

    // `config.label` is still available here.
    (checker, config.label)
}

fn demo_bind_first() {
    let cfg = Config { threshold: 5, label: String::from("info") };
    let (check, label) = make_checker(cfg);
    println!("label returned: {label}");
    assert!(check());
}
;
Ok(())
}
fn main() {}
