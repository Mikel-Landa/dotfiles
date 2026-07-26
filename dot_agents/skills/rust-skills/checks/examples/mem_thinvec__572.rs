#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// ✅ Good: Many instances, often empty
struct SparseGraph {
    nodes: Vec<Node>,
    // Most edges lists are empty or small
    edges: Vec<ThinVec<EdgeId>>,  // Saves 16 bytes per node
}

// ✅ Good: Nullable collection field
struct Document {
    content: String,
    attachments: ThinVec<Attachment>,  // Often empty
}

// ❌ Avoid: Hot loops, performance-critical iteration
fn process_hot_path(data: &ThinVec<Item>) {
    // Every length check goes through pointer indirection
    for item in data {  // Vec would be faster here
        process(item);
    }
}

// ❌ Avoid: Few instances
fn main() {
    let single_vec: ThinVec<i32> = ThinVec::new();
    // Saving 16 bytes once is meaningless
}
