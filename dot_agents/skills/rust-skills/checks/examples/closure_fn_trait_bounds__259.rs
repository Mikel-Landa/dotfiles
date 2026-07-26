#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Use FnOnce when you call the closure exactly once.
fn run_once<F: FnOnce() -> String>(f: F) -> String {
    f()
}

// Use FnMut when you call the closure multiple times and it may mutate state.
fn retry<F: FnMut() -> bool>(mut f: F, attempts: usize) -> bool {
    for _ in 0..attempts {
        if f() {
            return true;
        }
    }
    false
}

// Use Fn when you call the closure multiple times and need it shareable/re-entrant.
fn for_each<T, F: Fn(&T)>(items: &[T], f: F) {
    for item in items {
        f(item);
    }
}

fn demo() {
    // FnOnce: move-consuming closure is accepted
    let s = String::from("hello");
    let result = run_once(move || s.to_uppercase());
    assert_eq!(result, "HELLO");

    // FnMut: closure mutates a counter
    let mut count = 0usize;
    let found = retry(
        || {
            count += 1;
            count == 3
        },
        5,
    );
    assert!(found);

    // Fn: read-only closure, called once per element
    let nums = vec![1, 2, 3];
    for_each(&nums, |n| println!("{n}"));
}
;
Ok(())
}
fn main() {}
