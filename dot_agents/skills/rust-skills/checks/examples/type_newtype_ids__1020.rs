#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct UserId(pub u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct PostId(pub u64);

fn get_user_posts(user_id: UserId, post_id: PostId) -> Vec<Post> {
    // Types are distinct
}

// This won't compile - types don't match
// let posts = get_user_posts(post_id, user_id);  // ERROR!

// Correct usage
let posts = get_user_posts(UserId(1), PostId(42));
;
Ok(())
}
fn main() {}
