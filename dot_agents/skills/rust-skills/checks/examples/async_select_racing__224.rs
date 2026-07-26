#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
async fn event_loop(
    mut commands: mpsc::Receiver<Command>,
    shutdown: CancellationToken,
) {
    loop {
        select! {
            _ = shutdown.cancelled() => {
                println!("Shutting down");
                break;
            }
            Some(cmd) = commands.recv() => {
                process_command(cmd).await;
            }
            else => {
                // commands channel closed
                break;
            }
        }
    }
}
;
Ok(())
}
fn main() {}
