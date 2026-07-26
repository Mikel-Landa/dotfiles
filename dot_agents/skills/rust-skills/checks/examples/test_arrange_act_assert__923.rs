#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
#[cfg(test)]
mod tests {
    use super::*;
    
    // Arrange helpers
    fn create_test_user() -> User {
        User::new("test", "test@example.com").unwrap()
    }
    
    fn create_order_with_items(items: &[(&str, f64)]) -> Order {
        let mut order = Order::new();
        for (name, price) in items {
            order.add_item(Item::new(name, *price));
        }
        order
    }
    
    // Assert helpers
    fn assert_order_total(order: &Order, expected: f64) {
        let total = order.calculate_total(0.0);
        assert!((total - expected).abs() < 0.01);
    }
    
    #[test]
    fn order_total_sums_items() {
        // Arrange
        let order = create_order_with_items(&[
            ("A", 10.0),
            ("B", 20.0),
        ]);
        
        // Act & Assert
        assert_order_total(&order, 30.0);
    }
}
fn main() {}
