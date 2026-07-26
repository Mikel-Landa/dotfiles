#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
macro_rules! swap {
    ($a:expr, $b:expr) => {{
        // `tmp` here does NOT interfere with any `tmp` in the caller's scope.
        let tmp = $a;
        $a = $b;
        $b = tmp;
    }};
}

fn main() {
    let tmp = "outer";        // unrelated to the macro's `tmp`
    let (mut x, mut y) = (1, 2);
    swap!(x, y);
    assert_eq!((x, y), (2, 1));
    assert_eq!(tmp, "outer"); // still intact
}
