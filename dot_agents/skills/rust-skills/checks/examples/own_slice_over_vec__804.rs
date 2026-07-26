#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Flexible - accepts any slice-like thing
fn sum(numbers: &[i32]) -> i32 {
    numbers.iter().sum()
}

// Flexible - accepts any string-like thing
fn greet(name: &str) {
    println!("Hello, {}", name);
}

// Now all of these work:
let vec = vec![1, 2, 3];
let arr = [4, 5, 6];
let slice = &vec[0..2];

sum(&vec);    // Vec coerces to slice
sum(&arr);    // Array coerces to slice
sum(slice);   // Slice works directly

let string = String::from("Alice");
let literal = "Bob";

greet(&string);  // String coerces to &str
greet(literal);  // &str works directly
;
Ok(())
}
fn main() {}
