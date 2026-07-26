#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
async fn run_server(shutdown: CancellationToken) {
    let listener = TcpListener::bind("0.0.0.0:8080").await?;
    
    loop {
        tokio::select! {
            _ = shutdown.cancelled() => {
                println!("Server shutting down");
                break;
            }
            result = listener.accept() => {
                let (socket, _) = result?;
                // Each connection gets child token
                let conn_token = shutdown.child_token();
                tokio::spawn(handle_connection(socket, conn_token));
            }
        }
    }
    
    // Child tokens auto-cancelled when we exit
}

async fn handle_connection(socket: TcpStream, token: CancellationToken) {
    loop {
        tokio::select! {
            _ = token.cancelled() => {
                // Connection cleanup
                break;
            }
            data = socket.read() => {
                // Handle data
            }
        }
    }
}
;
Ok(())
}
fn main() {}
