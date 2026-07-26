#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Reusable macro for serde derives
#[cfg(feature = "serde")]
macro_rules! impl_serde {
    ($($t:ty),*) => {
        $(
            impl serde::Serialize for $t {
                // ...
            }
            impl<'de> serde::Deserialize<'de> for $t {
                // ...
            }
        )*
    };
}

#[cfg(not(feature = "serde"))]
macro_rules! impl_serde {
    ($($t:ty),*) => {};
}

// Or use cfg_attr for derived impls
#[derive(Debug, Clone)]
#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]
pub struct Point {
    pub x: f64,
    pub y: f64,
}
;
Ok(())
}
fn main() {}
