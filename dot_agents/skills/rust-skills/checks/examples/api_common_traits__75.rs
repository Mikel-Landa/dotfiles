#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// At minimum, public types should have:
#[derive(Debug, Clone, PartialEq)]
pub struct MyType { ... }

// Add based on use case:
// + Eq, Hash       → for HashMap keys
// + Ord, PartialOrd → for BTreeMap, sorting
// + Default        → for Option::unwrap_or_default()
// + Copy           → for small value types
// + Serialize      → for serialization
;
Ok(())
}
fn main() {}
