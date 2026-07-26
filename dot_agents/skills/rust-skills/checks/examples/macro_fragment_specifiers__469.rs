#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
macro_rules! debug_val {
    // :expr captures a single expression; the follow-set allows `=>` and `,` after it.
    ($e:expr) => {
        println!("{} = {:?}", stringify!($e), $e);
    };
}

fn main() {
    debug_val!(1 + 2);
    // debug_val!(let x = 1); // now correctly rejected at the macro call site
}
