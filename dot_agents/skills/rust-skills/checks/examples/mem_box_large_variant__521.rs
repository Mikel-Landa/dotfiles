#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
enum Event {
    Small(u32),
    Large(Box<LargeData>),
}

fn handle(event: Event) {
    match event {
        Event::Small(n) => println!("Small: {}", n),
        Event::Large(data) => {
            // data is Box<LargeData>, dereference to access
            println!("Large: {} bytes", data.size);
        }
    }
}

// Or match on reference
fn handle_ref(event: &Event) {
    match event {
        Event::Small(n) => println!("Small: {}", n),
        Event::Large(data) => {
            // data is &Box<LargeData>, auto-derefs
            println!("Large: {} bytes", data.size);
        }
    }
}
;
Ok(())
}
fn main() {}
