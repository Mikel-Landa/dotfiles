#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use rayon::prelude::*;

fn sum_squares(data: &[f64]) -> f64 {
    data.par_iter().map(|x| x * x).sum()
}

fn normalize(data: &mut [f64]) {
    let max = data.par_iter().cloned().reduce(|| f64::NEG_INFINITY, f64::max);
    data.par_iter_mut().for_each(|x| *x /= max);
}

fn keep_positive(data: &[f64]) -> Vec<f64> {
    data.par_iter().copied().filter(|&x| x > 0.0).collect()
}

fn sort_large(data: &mut [f64]) {
    // parallel unstable sort — faster than std sort for large slices
    data.par_sort_unstable_by(|a, b| a.partial_cmp(b).unwrap());
}
;
Ok(())
}
fn main() {}
