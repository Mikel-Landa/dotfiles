#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// checked_add: returns None on overflow — propagate or handle the error
fn add_score(current: u32, delta: u32) -> Option<u32> {
    current.checked_add(delta)
}

// saturating_add: clamps at the type's upper bound (u8::MAX == 255)
fn increment_saturating(c: u8) -> u8 {
    c.saturating_add(1)
}

// wrapping_add: intentional modular (two's complement) arithmetic
fn wrapping_sequence(n: u8) -> u8 {
    n.wrapping_add(1)
}

// overflowing_add: returns (result, did_overflow) — useful for carry detection
fn add_with_carry(a: u32, b: u32) -> (u32, bool) {
    a.overflowing_add(b)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn checked_returns_none_on_overflow() {
        assert_eq!(add_score(u32::MAX, 1), None);
        assert_eq!(add_score(10, 5), Some(15));
    }

    #[test]
    fn saturating_clamps_at_max() {
        assert_eq!(increment_saturating(255), 255);
        assert_eq!(increment_saturating(10), 11);
    }

    #[test]
    fn wrapping_rolls_over() {
        assert_eq!(wrapping_sequence(255), 0);
    }

    #[test]
    fn overflowing_reports_carry() {
        assert_eq!(add_with_carry(u32::MAX, 1), (0, true));
        assert_eq!(add_with_carry(1, 2), (3, false));
    }
}
fn main() {}
