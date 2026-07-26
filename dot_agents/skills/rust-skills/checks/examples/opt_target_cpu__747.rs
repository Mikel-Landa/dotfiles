#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// For portable binaries that use native features when available
#[cfg(target_arch = "x86_64")]
fn process_fast(data: &[u8]) -> u64 {
    if is_x86_feature_detected!("avx2") {
        // SAFETY: only reached after avx2 is detected at runtime
        unsafe { process_avx2(data) }
    } else {
        process_generic(data)
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn process_avx2(data: &[u8]) -> u64 {
    // an AVX2-optimized path would go here; delegate to the scalar version
    process_generic(data)
}

fn process_generic(data: &[u8]) -> u64 {
    data.iter().map(|&b| u64::from(b)).sum()
}
;
Ok(())
}
fn main() {}
