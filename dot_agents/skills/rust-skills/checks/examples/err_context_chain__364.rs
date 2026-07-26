#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process_order(order_id: u64) -> Result<()> {
    let order = fetch_order(order_id)
        .with_context(|| format!("failed to fetch order {}", order_id))?;
    
    let user = load_user(order.user_id)
        .with_context(|| format!("failed to load user for order {}", order_id))?;
    
    let payment = process_payment(&order, &user)
        .context("payment processing failed")?;
    
    ship_order(&order, &payment)
        .context("shipping failed")?;
    
    Ok(())
}

// Full error chain:
// "shipping failed"
// Caused by: "carrier API returned 503"
// Caused by: "connection refused"
;
Ok(())
}
fn main() {}
