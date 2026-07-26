#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum OrderStatus {
    Pending,
    Processing,
    Completed,
    Cancelled,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
enum Priority {
    Low,
    Medium,
    High,
    Critical,
}

fn process_order(status: OrderStatus, priority: Priority) {
    match status {
        OrderStatus::Pending => { ... }
        OrderStatus::Processing => { ... }
        OrderStatus::Completed => { ... }
        OrderStatus::Cancelled => { ... }
    }  // Exhaustive - compiler checks all cases
}

// Validated newtypes
struct Email(String);
struct PhoneNumber(String);
struct UserId(u64);

impl Email {
    pub fn new(s: &str) -> Result<Self, ValidationError> {
        if is_valid_email(s) {
            Ok(Email(s.to_string()))
        } else {
            Err(ValidationError::InvalidEmail)
        }
    }
}

struct User {
    email: Email,       // Must be valid email
    phone: PhoneNumber, // Must be valid phone
    user_id: UserId,    // Can't confuse with other IDs
}

// Compile errors catch mistakes
process_order(OrderStatus::Completed, Priority::High);  // Clear and correct
process_order(Priority::High, OrderStatus::Pending);    // Compile error!
;
Ok(())
}
fn main() {}
