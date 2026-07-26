#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn classify(n: u32) -> String {
    match n {
        id @ 1..=9 => format!("single digit: {id}"),
        id @ 10..=99 => format!("two digits: {id}"),
        _ => String::from("large"),
    }
}

// Nested struct field with @ binding
#[derive(Debug)]
enum Command {
    Move { x: i32, y: i32 },
}

fn validate_move(cmd: &Command) {
    match cmd {
        Command::Move { x: x_pos @ 0..=100, y } => {
            println!("valid move to x={x_pos}, y={y}");
        }
        _ => println!("invalid command"),
    }
}
;
Ok(())
}
fn main() {}
