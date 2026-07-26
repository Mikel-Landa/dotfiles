#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
impl User {
    // Clear: answers "is the user active?"
    fn is_active(&self) -> bool { ... }
    
    // Clear: answers "is the user deleted?"
    fn is_deleted(&self) -> bool { ... }
    
    // Clear: answers "is the user an admin?"
    fn is_admin(&self) -> bool { ... }
    
    // Clear: answers "does the user have permission X?"
    fn has_permission(&self, perm: Permission) -> bool { ... }
    
    // Clear: answers "can the user edit?"
    fn can_edit(&self) -> bool { ... }
}

// Reads naturally
if user.is_active() && user.has_permission(Permission::Write) {
    // ...
}
;
Ok(())
}
fn main() {}
