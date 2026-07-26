#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
pub struct Parser {
    // Private implementation
    state: ParserState,
}

// Expose for testing but not public API
#[cfg(test)]
pub(crate) fn debug_state(&self) -> &ParserState {
    &self.state
}

// Or use a dedicated test helper
#[doc(hidden)]
pub mod __test_helpers {
    pub use super::ParserState;
}
fn main() {}
