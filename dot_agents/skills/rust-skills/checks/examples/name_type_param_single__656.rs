#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Keep type params short, move complexity to where clause
fn process<T, E>(value: T) -> Result<T, E>
where
    T: Clone + Debug + Send + Sync,
    E: Error + From<IoError>,
{ ... }

// Not inline
fn process<T: Clone + Debug + Send + Sync, E: Error + From<IoError>>(value: T) -> Result<T, E>
// Too long!
;
Ok(())
}
fn main() {}
