#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// lib.rs — std is opt-in, no_std is the default baseline
#![cfg_attr(not(feature = "std"), no_std)]

#[cfg(feature = "std")]
use std::vec::Vec;

#[cfg(not(feature = "std"))]
use alloc::vec::Vec;
fn main() {}
