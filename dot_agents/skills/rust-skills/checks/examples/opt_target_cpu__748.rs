#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// With AVX2 enabled:
// - 256-bit SIMD operations
// - Better autovectorization
// - FMA (fused multiply-add)
// - BMI (bit manipulation)

// Example: sum of squares
fn sum_squares(data: &[f64]) -> f64 {
    data.iter().map(|x| x * x).sum()
}
// Generic: scalar loop
// AVX2: processes 4 f64s per iteration
;
Ok(())
}
fn main() {}
