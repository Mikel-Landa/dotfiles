#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// DON'T inline large functions - hurts instruction cache
#[inline(always)]  // BAD for large function
fn large_complex_function(data: &mut [u8]) {
    // 100+ lines of code
    // Inlining bloats every call site
}

// DON'T assume inlining always helps - measure!
// Sometimes the compiler makes better decisions

// Cross-crate inlining requires #[inline] on each function
// Without LTO, a function body is not available to other crates unless
// it carries #[inline]. Within a single crate (or with LTO enabled),
// the compiler may still inline `inner` transitively after inlining
// `outer`, but this is not guaranteed — verify hot code with assembly.
#[inline]
fn outer() {
    inner();
}

fn inner() { }  // May not be inlined at outer's call sites across crate boundaries without #[inline]
;
Ok(())
}
fn main() {}
