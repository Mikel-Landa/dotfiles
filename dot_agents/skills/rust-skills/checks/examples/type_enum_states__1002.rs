#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl Connection {
    fn connect(&mut self, addr: SocketAddr) -> Result<(), Error> {
        match &self.state {
            ConnectionState::Disconnected => {
                self.state = ConnectionState::Connecting { address: addr };
                Ok(())
            }
            _ => Err(Error::AlreadyConnected),
        }
    }
    
    fn on_connected(&mut self, socket: TcpStream) {
        if let ConnectionState::Connecting { .. } = &self.state {
            self.state = ConnectionState::Connected { socket };
        }
    }
    
    fn authenticate(&mut self, creds: Credentials) -> Result<(), Error> {
        match std::mem::replace(&mut self.state, ConnectionState::Disconnected) {
            ConnectionState::Connected { socket } => {
                let session = perform_auth(&socket, creds)?;
                self.state = ConnectionState::Authenticated { socket, session };
                Ok(())
            }
            other => {
                self.state = other;
                Err(Error::NotConnected)
            }
        }
    }
}
;
Ok(())
}
fn main() {}
