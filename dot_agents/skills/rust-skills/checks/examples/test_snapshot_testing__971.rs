#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use insta::assert_debug_snapshot;
use insta::assert_json_snapshot;

#[test]
fn test_render_error() {
    let err = AppError::NotFound { id: 42 };
    // On first run: creates snapshots/test_render_error.snap
    // On subsequent runs: diffs against the saved snapshot
    assert_debug_snapshot!(err);
}

#[test]
fn test_config_serialization() {
    let config = Config::default();
    // Snapshot stored as pretty-printed JSON for easy review
    assert_json_snapshot!(config);
}

#[test]
fn test_cli_output() {
    let output = run_cli(&["--help"]);
    // Named snapshot for clarity
    assert_debug_snapshot!("cli_help_output", output);
}
;
Ok(())
}
fn main() {}
