#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
trait Transformer {
    // Core dispatchable method — always in the vtable.
    fn transform_str(&self, value: &str) -> String;

    fn name(&self) -> &str;

    // Generic convenience method gated with `where Self: Sized`.
    // Callers can use it via a concrete type; it is excluded from `dyn Transformer`.
    fn transform_debug<T: std::fmt::Debug>(&self, value: T) -> String
    where
        Self: Sized,
    {
        self.transform_str(&format!("{value:?}"))
    }
}

// ----- Implementations -----

struct Shout;
impl Transformer for Shout {
    fn transform_str(&self, value: &str) -> String { value.to_uppercase() }
    fn name(&self) -> &str { "shout" }
}

struct Whisper;
impl Transformer for Whisper {
    fn transform_str(&self, value: &str) -> String { value.to_lowercase() }
    fn name(&self) -> &str { "whisper" }
}

// ----- Object-safe usage -----

fn apply_all(transformers: &[Box<dyn Transformer>], input: &str) {
    for t in transformers {
        println!("[{}] {}", t.name(), t.transform_str(input));
    }
}

// ----- Generic (static) usage — can call the `where Self: Sized` method -----

fn apply_generic<T: Transformer>(t: &T, value: i32) -> String {
    t.transform_debug(value)  // available because T: Sized
}

fn demo() {
    let ts: Vec<Box<dyn Transformer>> = vec![
        Box::new(Shout),
        Box::new(Whisper),
    ];
    apply_all(&ts, "Hello World");

    // Static dispatch path can use the generic helper.
    let result = apply_generic(&Shout, 42);
    println!("{result}");
}
;
Ok(())
}
fn main() {}
