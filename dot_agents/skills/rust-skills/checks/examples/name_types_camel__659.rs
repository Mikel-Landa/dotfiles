#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Treat acronyms as words (capitalize first letter only)
struct HttpServer { ... }      // Not HTTPServer
struct JsonParser { ... }      // Not JSONParser
struct Uuid { ... }            // Not UUID
struct TcpStream { ... }       // Not TCPStream

// Exception: Two-letter acronyms can be all caps
struct IOError { ... }         // Acceptable
struct IoError { ... }         // Also acceptable (preferred)
;
Ok(())
}
fn main() {}
