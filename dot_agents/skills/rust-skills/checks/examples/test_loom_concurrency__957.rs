#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// tests/loom_flag.rs  (or inside a #[cfg(loom)] mod in the crate)
#[cfg(loom)]
mod tests {
    use loom::sync::Arc;
    use super::Flag;

    #[test]
    fn flag_set_visible_to_other_thread() {
        loom::model(|| {
            let flag = Arc::new(Flag::new());

            let flag2 = Arc::clone(&flag);
            let writer = loom::thread::spawn(move || {
                flag2.set();
            });

            // All interleavings: either writer runs first or reader does.
            // loom verifies the Acquire/Release pair holds in both cases.
            let seen = flag.is_set();
            writer.join().unwrap();

            // After join, writer must have completed; flag must be set.
            assert!(flag.is_set(), "flag must be set after join");
            // 'seen' may be false if reader ran before writer — that is valid.
            let _ = seen;
        });
    }
}
fn main() {}
