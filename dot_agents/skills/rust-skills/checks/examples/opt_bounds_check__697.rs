#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn matrix_multiply(a: &[f64], b: &[f64], c: &mut [f64], n: usize) {
    assert!(a.len() >= n * n);
    assert!(b.len() >= n * n);
    assert!(c.len() >= n * n);
    
    for i in 0..n {
        for j in 0..n {
            let mut sum = 0.0;
            for k in 0..n {
                // SAFETY: bounds verified by asserts above
                unsafe {
                    sum += a.get_unchecked(i * n + k) 
                         * b.get_unchecked(k * n + j);
                }
            }
            // SAFETY: bounds verified by asserts above
            unsafe {
                *c.get_unchecked_mut(i * n + j) = sum;
            }
        }
    }
}
;
Ok(())
}
fn main() {}
