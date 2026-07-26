#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// approximate equality with an absolute epsilon
fn approx_eq(a: f64, b: f64, epsilon: f64) -> bool {
    (a - b).abs() < epsilon
}

fn is_unit_length(x: f64, y: f64) -> bool {
    approx_eq((x * x + y * y).sqrt(), 1.0, 1e-9)
}

// total ordering: NaN sorts after everything else (consistent, never panics)
fn sort_scores(scores: &mut Vec<f64>) {
    scores.sort_by(|a, b| a.total_cmp(b));
}

// direct NaN check when needed
fn safe_reciprocal(x: f64) -> Option<f64> {
    if x == 0.0 || x.is_nan() {
        None
    } else {
        Some(1.0 / x)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn float_addition_is_not_exact() {
        assert_ne!(0.1_f64 + 0.2, 0.3);  // IEEE 754 rounding
        assert!(approx_eq(0.1 + 0.2, 0.3, 1e-10));
    }

    #[test]
    fn nan_is_not_equal_to_itself() {
        let nan = f64::NAN;
        assert_ne!(nan, nan);  // NaN != NaN by IEEE 754
    }

    #[test]
    fn total_cmp_handles_nan() {
        let mut v = vec![3.0_f64, f64::NAN, 1.0, f64::NAN, 2.0];
        sort_scores(&mut v);
        // NaN values sort to the end; finite values are in order
        assert_eq!(&v[..3], &[1.0, 2.0, 3.0]);
        assert!(v[3].is_nan());
        assert!(v[4].is_nan());
    }

    #[test]
    fn unit_length_uses_tolerance() {
        assert!(is_unit_length(1.0, 0.0));
        assert!(is_unit_length(0.6, 0.8));  // 3-4-5 right triangle scaled
    }
}
fn main() {}
