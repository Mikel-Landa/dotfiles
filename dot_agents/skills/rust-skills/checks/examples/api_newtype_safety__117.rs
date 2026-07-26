#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct UserId(u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
struct GroupId(u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct Timestamp(u64);

struct User {
    id: UserId,
    group_id: GroupId,
    created_at: Timestamp,
}

fn add_user_to_group(user_id: UserId, group_id: GroupId) { ... }

// Compile error: expected UserId, found GroupId
let user = User { ... };
add_user_to_group(user.group_id, user.id);  // Error!

// Compile error: expected UserId, found Timestamp
add_user_to_group(user.created_at, user.group_id);  // Error!
;
Ok(())
}
fn main() {}
