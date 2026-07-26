#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::sync::broadcast;

#[derive(Clone, Debug)]
enum AppEvent {
    UserLoggedIn { user_id: u64 },
    OrderCreated { order_id: u64 },
    SystemShutdown,
}

struct EventBus {
    tx: broadcast::Sender<AppEvent>,
}

impl EventBus {
    fn new() -> Self {
        let (tx, _) = broadcast::channel(1000);
        EventBus { tx }
    }
    
    fn publish(&self, event: AppEvent) {
        // Ignore error if no subscribers
        let _ = self.tx.send(event);
    }
    
    fn subscribe(&self) -> broadcast::Receiver<AppEvent> {
        self.tx.subscribe()
    }
}

// Usage
let bus = EventBus::new();

// Logger subscribes
let mut log_rx = bus.subscribe();
tokio::spawn(async move {
    while let Ok(event) = log_rx.recv().await {
        log::info!("Event: {:?}", event);
    }
});

// Metrics subscribes
let mut metrics_rx = bus.subscribe();
tokio::spawn(async move {
    while let Ok(event) = metrics_rx.recv().await {
        record_metric(&event);
    }
});

// Publish events
bus.publish(AppEvent::UserLoggedIn { user_id: 42 });
;
Ok(())
}
fn main() {}
