#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::watch;
use std::sync::Arc;

struct AppConfig {
    log_level: Level,
    max_connections: usize,
}

async fn config_watcher(tx: watch::Sender<Arc<AppConfig>>) {
    loop {
        tokio::time::sleep(Duration::from_secs(60)).await;
        
        if let Ok(new_config) = reload_config_from_disk() {
            // Only notifies if value actually changed
            tx.send_if_modified(|current| {
                if *current != new_config {
                    *current = Arc::new(new_config);
                    true
                } else {
                    false
                }
            });
        }
    }
}

async fn worker(mut config_rx: watch::Receiver<Arc<AppConfig>>) {
    loop {
        tokio::select! {
            _ = config_rx.changed() => {
                let config = config_rx.borrow().clone();
                reconfigure(&config);
            }
            _ = do_work() => {}
        }
    }
}
;
Ok(())
}
fn main() {}
