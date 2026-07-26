#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// From a hypothetical external crate:
// #[non_exhaustive]
// pub enum TheirEvent { Click, Hover, /* ... future variants */ }

fn handle_event(event: &some_crate::TheirEvent) {
    match event {
        some_crate::TheirEvent::Click => { /* ... */ }
        some_crate::TheirEvent::Hover => { /* ... */ }
        // required by #[non_exhaustive]; intentionally a no-op for unknown variants
        _ => {}
    }
}
;
Ok(())
}
fn main() {}
