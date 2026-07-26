#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// try_join! cancels remaining futures on error
async fn with_cancellation() -> Result<()> {
    // If fetch_a() fails, fetch_b() and fetch_c() are dropped
    // But "dropped" != "immediately stopped"
    // They stop at their next .await point
    
    try_join!(
        async {
            fetch_a().await?;
            cleanup_a().await;  // May not run if other future fails
            Ok::<_, Error>(())
        },
        async {
            fetch_b().await?;
            cleanup_b().await;  // May not run if other future fails
            Ok::<_, Error>(())
        },
    )?;
    
    Ok(())
}

// For guaranteed cleanup, use Drop guards or explicit handling
;
Ok(())
}
fn main() {}
