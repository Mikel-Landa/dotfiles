#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Option 1: Return Result from main
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = load_config()?;
    run_app(config)?;
    Ok(())
}

// Option 2: Handle in main, exit on error
fn main() {
    if let Err(e) = run() {
        eprintln!("Error: {:#}", e);
        std::process::exit(1);
    }
}

fn run() -> anyhow::Result<()> {
    let config = load_config()?;
    run_app(config)?;
    Ok(())
}
