#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::fmt;

// Extension trait that any `Display` type receives automatically.
trait Describe {
    fn describe(&self) -> String;
}

// One blanket impl covers every T: Display — mirrors how std blanket-impls ToString.
impl<T: fmt::Display> Describe for T {
    fn describe(&self) -> String {
        format!("{} ({})", self, std::any::type_name::<T>())
    }
}

// ----- Downstream usage: zero extra code required -----

fn print_described(value: &impl Describe) {
    println!("{}", value.describe());
}

fn demo() {
    print_described(&42_i32);
    print_described(&3.14_f64);
    print_described(&true);
    print_described(&"hello");
}

// ----- You CANNOT also override it for one type -----
// Writing `impl Describe for MyType` while the blanket impl exists is a
// coherence conflict (E0119): stable Rust has no specialization, so a blanket
// impl and a specific impl can never overlap. If you need a per-type override,
// don't use a blanket impl — or wrap the type in a newtype (see See Also).
;
Ok(())
}
fn main() {}
