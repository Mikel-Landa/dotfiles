#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn make_transform(double: bool) -> Box<dyn Fn(i32) -> i32> {
    if double {
        Box::new(|x| x * 2)   // one concrete type
    } else {
        Box::new(|x| x + 100) // different concrete type
    }
    // `impl Fn` would fail: "expected closure, found a different closure"
}

// Storing heterogeneous closures also requires boxing:
struct Pipeline {
    steps: Vec<Box<dyn Fn(i32) -> i32>>,
}

impl Pipeline {
    fn new() -> Self {
        Self { steps: Vec::new() }
    }

    fn add_step(&mut self, f: impl Fn(i32) -> i32 + 'static) {
        self.steps.push(Box::new(f));
    }

    fn run(&self, mut value: i32) -> i32 {
        for step in &self.steps {
            value = step(value);
        }
        value
    }
}

fn demo_pipeline() {
    let mut p = Pipeline::new();
    p.add_step(|x| x + 1);
    p.add_step(|x| x * 3);
    assert_eq!(p.run(4), 15);
}
;
Ok(())
}
fn main() {}
