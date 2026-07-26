#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// ✅ Good: Many short strings in memory
struct Dictionary {
    words: Vec<CompactString>,  // Millions of short words
}

// ✅ Good: Frequently cloned strings
struct Template {
    parts: Vec<EcoString>,  // O(1) clone
}

// ❌ Don't: Hot path string manipulation
fn transform(s: &str) -> String {
    // Standard String is optimized for manipulation
    s.to_uppercase()
}

// ❌ Don't: API boundaries (prefer &str or String for interop)
pub fn public_api(input: CompactString) { }  // Forces dependency
pub fn public_api(input: impl Into<String>) { }  // Better
;
Ok(())
}
fn main() {}
