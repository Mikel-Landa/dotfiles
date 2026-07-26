#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// lib.rs

#[doc(hidden)]
pub mod __private {
    // Everything re-exported here is technically public (required for
    // macro call sites), but hidden from rendered docs and clearly
    // marked as an unstable implementation detail.
    pub use crate::helpers::format_value;
}

// Internal module — not public.
mod helpers {
    pub fn format_value(v: &dyn std::fmt::Debug) -> String {
        format!("{v:?}")
    }
}

#[macro_export]
macro_rules! debug_print {
    ($val:expr) => {
        // Reference through __private; never through the bare crate root.
        println!("{}", $crate::__private::format_value(&$val));
    };
}
fn main() {}
