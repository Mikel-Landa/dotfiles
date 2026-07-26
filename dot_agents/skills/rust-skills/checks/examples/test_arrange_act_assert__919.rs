#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[test]
fn new_user_has_correct_name() {
    // Arrange
    let name = "alice";
    let email = "alice@example.com";
    
    // Act
    let user = User::new(name, email).unwrap();
    
    // Assert
    assert_eq!(user.name(), "alice");
}

#[test]
fn user_creation_fails_with_empty_name() {
    // Arrange
    let name = "";
    let email = "email@example.com";
    
    // Act
    let result = User::new(name, email);
    
    // Assert
    assert!(result.is_err());
    assert!(matches!(result, Err(UserError::EmptyName)));
}
;
Ok(())
}
fn main() {}
