#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::num::NonZeroU32;
use std::mem::size_of;

// zero is rejected at construction; division is always safe
fn divide(numerator: u32, denominator: NonZeroU32) -> u32 {
    numerator / denominator.get()
}

// ID is guaranteed non-zero; Option<WidgetId> is free
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct WidgetId(NonZeroU32);

impl WidgetId {
    /// Returns `None` if `id` is zero.
    pub fn new(id: u32) -> Option<Self> {
        NonZeroU32::new(id).map(WidgetId)
    }

    pub fn get(self) -> u32 {
        self.0.get()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::num::NonZeroU32;

    #[test]
    fn nonzero_new_returns_none_for_zero() {
        assert!(NonZeroU32::new(0).is_none());
        assert!(NonZeroU32::new(1).is_some());
    }

    #[test]
    fn option_nonzero_is_same_size_as_u32() {
        // niche optimization: no space overhead for Option
        assert_eq!(size_of::<Option<NonZeroU32>>(), size_of::<u32>());
        assert_eq!(size_of::<Option<NonZeroU32>>(), 4);
    }

    #[test]
    fn widget_id_rejects_zero() {
        assert!(WidgetId::new(0).is_none());
        let id = WidgetId::new(42).unwrap();
        assert_eq!(id.get(), 42);
    }

    #[test]
    fn divide_uses_nonzero_denominator() {
        let denom = NonZeroU32::new(3).unwrap();
        assert_eq!(divide(12, denom), 4);
    }
}
fn main() {}
