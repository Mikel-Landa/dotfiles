#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
fn apply_damage(health: i32, damage: i32) -> i32 {
    // saturating_sub stops at i32::MIN — then clamp ensures non-negative
    health.saturating_sub(damage).clamp(0, i32::MAX)
}

fn clamp_volume(vol: u8, min: u8, max: u8) -> u8 {
    vol.clamp(min, max)
}

// integer clamp: any Ord type
fn clamp_score(score: i64) -> i64 {
    score.clamp(0, 100)
}

// float clamp: available on f32/f64 since Rust 1.50
fn normalize_alpha(a: f32) -> f32 {
    a.clamp(0.0, 1.0)  // NaN propagates: NaN.clamp(0.0, 1.0) == NaN
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn damage_does_not_go_below_zero() {
        assert_eq!(apply_damage(10, 5), 5);
        assert_eq!(apply_damage(3, 100), 0);
    }

    #[test]
    fn volume_is_bounded() {
        assert_eq!(clamp_volume(50, 10, 90), 50);
        assert_eq!(clamp_volume(5, 10, 90), 10);
        assert_eq!(clamp_volume(200, 10, 90), 90);
    }

    #[test]
    fn score_is_clamped() {
        assert_eq!(clamp_score(-10), 0);
        assert_eq!(clamp_score(150), 100);
        assert_eq!(clamp_score(75), 75);
    }

    #[test]
    fn float_nan_propagates_through_clamp() {
        assert!(f32::NAN.clamp(0.0, 1.0).is_nan());
    }
}
fn main() {}
