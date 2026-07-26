#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// build.rs — narrow directives, capability probe via autocfg, no network
fn main() {
    // Only re-run when these specific files change
    println!("cargo::rerun-if-changed=build.rs");
    println!("cargo::rerun-if-changed=src/generated.rs");
    println!("cargo::rerun-if-env-changed=MY_BUILD_FLAG");

    // Probe actual compiler capability instead of parsing version strings
    let ac = autocfg::new();
    // Emit cfg if the compiler supports the feature we need
    ac.emit_has_type("std::collections::BTreeMap");

    // Conditional cfg from env var
    if std::env::var("MY_BUILD_FLAG").is_ok() {
        println!("cargo::rustc-cfg=my_feature");
    }
}
