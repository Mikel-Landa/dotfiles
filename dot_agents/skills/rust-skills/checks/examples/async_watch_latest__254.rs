#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Clone, PartialEq)]
enum ConnectionState {
    Disconnected,
    Connecting,
    Connected,
    Error(String),
}

struct Connection {
    state_tx: watch::Sender<ConnectionState>,
    state_rx: watch::Receiver<ConnectionState>,
}

impl Connection {
    async fn wait_connected(&mut self) -> Result<(), Error> {
        loop {
            let state = self.state_rx.borrow().clone();
            match state {
                ConnectionState::Connected => return Ok(()),
                ConnectionState::Error(e) => return Err(Error::Connection(e)),
                _ => {
                    self.state_rx.changed().await?;
                }
            }
        }
    }
}
;
Ok(())
}
fn main() {}
