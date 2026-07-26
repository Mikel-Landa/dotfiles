#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Won't compile - infinite size
enum List {
    Cons(i32, List),
    Nil,
}

// Must box recursive variant
enum List {
    Cons(i32, Box<List>),  // Now finite size
    Nil,
}

// Same for ASTs
enum Expr {
    Number(i64),
    BinOp {
        op: Op,
        left: Box<Expr>,   // Recursive - must box
        right: Box<Expr>,
    },
}
;
Ok(())
}
fn main() {}
