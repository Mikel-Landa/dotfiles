#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Allow implementing some methods but not all
mod private {
    pub trait SealedCore {}
}

pub trait Plugin: private::SealedCore {
    // Sealed - only we implement
    fn initialize(&self);
    fn shutdown(&self);
    
    // Open - users can override
    fn name(&self) -> &str { "unnamed" }
}

// Only we can add new required sealed methods
// Users can customize open methods
fn main() {}
