#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Timeout
select! {
    result = operation() => result,
    _ = sleep(Duration::from_secs(5)) => Err(Timeout),
}

// Cancellation
select! {
    result = operation() => result,
    _ = cancel_token.cancelled() => Err(Cancelled),
}

// Interval with cancellation
let mut interval = tokio::time::interval(Duration::from_secs(1));
loop {
    select! {
        _ = shutdown.cancelled() => break,
        _ = interval.tick() => {
            do_periodic_work().await;
        }
    }
}
;
Ok(())
}
fn main() {}
