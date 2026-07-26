#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::convert::TryFrom;

// widening: From<u8> for u32 is always lossless — won't compile if lossy
fn widen(x: u8) -> u32 {
    u32::from(x)
    // or: x.into()
}

// narrowing: TryFrom makes the failure case explicit
fn narrow(x: u32) -> Result<u8, <u8 as TryFrom<u32>>::Error> {
    u8::try_from(x)
    // or: x.try_into()
}

// float → integer: validate the range manually before casting
fn float_to_index(f: f64, len: usize) -> Option<usize> {
    if f.is_nan() || f < 0.0 || f >= len as f64 {
        return None;
    }
    Some(f as usize)  // `as` is acceptable here: range is verified above
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::TryFrom;

    #[test]
    fn widen_is_lossless() {
        assert_eq!(widen(255), 255u32);
    }

    #[test]
    fn narrow_errors_on_overflow() {
        assert!(narrow(300).is_err());
        assert_eq!(narrow(200), Ok(200u8));
    }

    #[test]
    fn float_to_index_rejects_nan_and_negative() {
        assert_eq!(float_to_index(f64::NAN, 10), None);
        assert_eq!(float_to_index(-1.0, 10), None);
        assert_eq!(float_to_index(3.9, 10), Some(3));
    }

    #[test]
    fn as_cast_truncation_footgun() {
        // demonstrating why `as` is dangerous for narrowing:
        let x: u32 = 300;
        assert_eq!(x as u8, 44);  // 300 % 256 == 44 — silently wrong
    }
}
fn main() {}
