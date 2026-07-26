#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Internal module with crate visibility
pub(crate) mod internal {
    pub(crate) struct InternalState {
        pub(crate) buffer: Vec<u8>,
        pub(crate) dirty: bool,
    }
    
    pub(crate) fn process_internal(state: &mut InternalState) {
        // Only callable within crate
    }
}

pub struct Widget {
    state: internal::InternalState,  // Private field
}

impl Widget {
    pub fn new() -> Self {
        Self {
            state: internal::InternalState {
                buffer: Vec::new(),
                dirty: false,
            }
        }
    }
    
    pub fn do_something(&mut self) {
        internal::process_internal(&mut self.state);
    }
}
fn main() {}
