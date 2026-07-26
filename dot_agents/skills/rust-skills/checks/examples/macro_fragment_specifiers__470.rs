#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
macro_rules! my_vec {
    ($($e:expr),* $(,)?) => {
        // $(,)? consumes an optional trailing comma, which is legal after :expr
        // because it appears as a separator/terminator, not in follow position.
        vec![$($e),*]
    };
}

let v = my_vec![1, 2, 3,]; // trailing comma accepted
;
Ok(())
}
fn main() {}
