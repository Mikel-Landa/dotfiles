#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process(data: &[i32]) -> i32 {
    data.iter().sum()
}

// Return a closure that owns its capture via `move`.
fn make_greeter(name: String) -> impl Fn() {
    move || println!("hello, {name}")
}

// Clone before `move` when you need the value in both places.
fn spawn_and_keep(data: Vec<i32>) -> std::thread::JoinHandle<i32> {
    let data_for_thread = data.clone(); // clone goes into the closure
    let handle = std::thread::spawn(move || process(&data_for_thread));
    // `data` is still available here
    println!("original still owned: {data:?}");
    handle
}

fn demo() {
    let greet = make_greeter(String::from("world"));
    greet(); // prints: hello, world

    let nums = vec![10, 20, 30];
    let handle = spawn_and_keep(nums);
    let sum = handle.join().unwrap();
    assert_eq!(sum, 60);
}
;
Ok(())
}
fn main() {}
