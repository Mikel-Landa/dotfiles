#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
use std::fmt;

#[derive(Debug)]
struct Port(u16);

#[derive(Debug)]
struct PortError(u32);

impl fmt::Display for PortError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "port {} is out of range (0–65535)", self.0)
    }
}

impl std::error::Error for PortError {}

impl TryFrom<u32> for Port {
    type Error = PortError;

    fn try_from(value: u32) -> Result<Self, Self::Error> {
        u16::try_from(value)
            .map(Port)
            .map_err(|_| PortError(value))
    }
}

fn accept_port(n: u32) -> Result<Port, PortError> {
    // Callers use the standard `.try_into()?` idiom
    n.try_into()
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let p: Port = 8080_u32.try_into()?;
    println!("port: {}", p.0);
    Ok(())
}
