#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/lib.rs
mod internal;  // Private module
pub mod api;   // Public API

// src/internal.rs
pub(crate) struct Helper;
pub(crate) fn helper_function() -> Helper { Helper }

// src/api.rs
use crate::internal::{Helper, helper_function};

pub struct PublicType {
    helper: Helper,  // Uses internal type, but field is private
}
fn main() {}
