#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Guaranteed same layout as inner type
#[repr(transparent)]
struct Handle(u64);

// Safe for FFI
extern "C" {
    fn process_handle(h: Handle);  // Works - same layout as u64
}

// FFI pointer wrapper
#[repr(transparent)]
struct SafePointer(*mut c_void);

impl SafePointer {
    // Safe Rust API around raw pointer
    pub fn new(ptr: *mut c_void) -> Option<Self> {
        if ptr.is_null() {
            None
        } else {
            Some(SafePointer(ptr))
        }
    }
}
;
Ok(())
}
fn main() {}
