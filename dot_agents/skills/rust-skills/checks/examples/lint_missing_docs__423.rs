#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#![warn(missing_docs)]

/// Documented module.
pub mod api {
    /// Documented struct.
    pub struct Config { }
    
    #[allow(missing_docs)]
    pub mod internal {
        // Internal API, docs not required
        pub struct Helper { }
    }
}
fn main() {}
