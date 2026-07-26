#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Extension only visible where imported
mod string_utils {
    pub trait StringExt {
        fn truncate_ellipsis(&self, max_len: usize) -> String;
    }
    
    impl StringExt for str {
        fn truncate_ellipsis(&self, max_len: usize) -> String {
            if self.len() <= max_len {
                self.to_string()
            } else {
                format!("{}...", &self[..max_len.saturating_sub(3)])
            }
        }
    }
}

// Only available when explicitly imported
use string_utils::StringExt;
let short = "very long string".truncate_ellipsis(10);
fn main() {}
