#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// ---- 1. Opt OUT of Send/Sync using PhantomData ----
// If your type logically owns a *const T (e.g. an intrusive pointer),
// use PhantomData to prevent the compiler from auto-deriving Send/Sync.
struct IntrinsiveRef<T> {
    ptr: *const T,
    // PhantomData<*const T> makes this type !Send + !Sync automatically,
    // matching the semantics of a raw non-owning pointer.
    _marker: PhantomData<*const T>,
}
// No unsafe impl needed — the compiler correctly withholds Send/Sync.

// ---- 2. Opt IN with a documented unsafe impl ----
use std::sync::Mutex;

/// A buffer owned exclusively by one thread at a time.
/// The raw pointer always points to a heap allocation this struct owns;
/// no other reference to that allocation exists outside this struct.
struct OwnedBuffer {
    ptr: *mut u8,
    len: usize,
}

// SAFETY: OwnedBuffer owns its allocation exclusively (no aliasing),
// and access is protected by the caller's Mutex<OwnedBuffer> at usage sites.
// The pointer is valid for the entire lifetime of OwnedBuffer.
unsafe impl Send for OwnedBuffer {}

// SAFETY: OwnedBuffer exposes no shared mutation — all methods require &mut self.
// Concurrent & references cannot mutate the buffer.
unsafe impl Sync for OwnedBuffer {}

// ---- 3. Prefer newtype wrappers around Arc for sharing ----
// Instead of manual Sync, wrap in Arc<Mutex<T>> so the compiler handles it.
use std::sync::Arc;

struct SafeCounter {
    value: Mutex<u32>,
}

// Arc<Mutex<u32>> is Send + Sync automatically — no manual impl required.
fn make_shared() -> Arc<SafeCounter> {
    Arc::new(SafeCounter { value: Mutex::new(0) })
}
;
Ok(())
}
fn main() {}
