#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[test]
fn order_total_includes_tax() {
    // Arrange
    let mut order = Order::new();
    order.add_item(Item::new("Widget", 100.00));
    order.add_item(Item::new("Gadget", 50.00));
    let tax_rate = 0.10;
    
    // Act
    let total = order.calculate_total(tax_rate);
    
    // Assert
    let expected = (100.00 + 50.00) * 1.10;
    assert_eq!(total, expected);
}
;
Ok(())
}
fn main() {}
