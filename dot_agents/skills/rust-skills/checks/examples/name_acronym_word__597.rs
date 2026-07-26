#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// std uses acronyms as words
std::net::TcpStream            // Not TCPStream
std::net::TcpListener          // Not TCPListener
std::net::UdpSocket            // Not UDPSocket
std::net::IpAddr               // Not IPAddr
std::io::IoError               // Not IOError (though Io is acceptable too)
;
Ok(())
}
fn main() {}
