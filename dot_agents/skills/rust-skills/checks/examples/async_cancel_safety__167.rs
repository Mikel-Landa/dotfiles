#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::io::{AsyncReadExt, BufReader};
use tokio::net::TcpStream;
use tokio::sync::mpsc;

// Cancel-safe: the buffer lives OUTSIDE the select loop.
// If the recv branch fires, buf retains whatever was already read,
// and the next iteration continues filling it.
async fn good_example(
    stream: &mut BufReader<TcpStream>,
    rx: &mut mpsc::Receiver<u8>,
) -> std::io::Result<()> {
    let mut buf = [0u8; 1024];
    let mut filled = 0;

    loop {
        tokio::select! {
            n = stream.read(&mut buf[filled..]) => {
                // `read` (not `read_exact`) is cancel-safe: it either
                // reads some bytes or returns immediately with 0.
                filled += n?;
                if filled == buf.len() {
                    println!("buffer full: {:?}", &buf[..]);
                    filled = 0;
                }
            }
            msg = rx.recv() => {
                println!("got message: {:?}", msg);
            }
        }
    }
}
;
Ok(())
}
fn main() {}
