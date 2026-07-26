#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// #[inline] - hint to inline, compiler may ignore
#[inline]
fn suggested_inline(x: i32) -> i32 { x + 1 }

// #[inline(always)] - force inline (almost always)
#[inline(always)]
fn force_inline(x: i32) -> i32 { x + 1 }

// #[inline(never)] - prevent inlining (for profiling, code size)
#[inline(never)]
fn no_inline(x: i32) -> i32 { x + 1 }

// No annotation - compiler decides based on heuristics
fn compiler_decides(x: i32) -> i32 { x + 1 }
;
Ok(())
}
fn main() {}
