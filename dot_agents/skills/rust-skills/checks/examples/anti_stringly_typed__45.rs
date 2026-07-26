#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::str::FromStr;

#[derive(Debug, Clone, Copy)]
enum OrderStatus {
    Pending,
    Processing,
    Completed,
    Cancelled,
}

impl FromStr for OrderStatus {
    type Err = ParseError;
    
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "pending" => Ok(OrderStatus::Pending),
            "processing" => Ok(OrderStatus::Processing),
            "completed" => Ok(OrderStatus::Completed),
            "cancelled" | "canceled" => Ok(OrderStatus::Cancelled),
            _ => Err(ParseError::UnknownStatus(s.to_string())),
        }
    }
}

// Parse at boundary, use types internally
fn handle_request(status_str: &str) -> Result<(), Error> {
    let status: OrderStatus = status_str.parse()?;  // Validate once
    process_order(status);  // Type-safe from here
    Ok(())
}
;
Ok(())
}
fn main() {}
