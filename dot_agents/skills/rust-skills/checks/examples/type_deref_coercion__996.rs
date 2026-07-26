#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Smart-pointer/transparent wrapper: correct use of Deref
struct MyBox<T>(T);

impl<T> std::ops::Deref for MyBox<T> {
    type Target = T;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl<T> std::ops::DerefMut for MyBox<T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

// Domain types: expose only the API you intend, explicitly
struct User {
    pub name: String,
    pub email: String,
}

struct AdminUser(User);

impl AdminUser {
    pub fn name(&self) -> &str {
        &self.0.name
    }

    pub fn email(&self) -> &str {
        &self.0.email
    }

    pub fn can_delete_users(&self) -> bool {
        true
    }
}

fn greet(admin: &AdminUser) {
    println!("hello, {}", admin.name()); // explicit, readable
}
;
Ok(())
}
fn main() {}
