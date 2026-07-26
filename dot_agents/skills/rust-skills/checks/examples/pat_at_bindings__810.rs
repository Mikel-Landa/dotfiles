#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone)]
enum Packet {
    Data(Vec<u8>),
    Control(u8),
}

fn log_data(packet: &Packet) {
    match packet {
        whole @ Packet::Data(bytes) if !bytes.is_empty() => {
            println!("non-empty packet: {whole:?}");
        }
        Packet::Data(_) => println!("empty data packet"),
        Packet::Control(code) => println!("control: {code}"),
    }
}
;
Ok(())
}
fn main() {}
