#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
select! {
    // Pattern = future => handler
    result = async_operation() => {
        // Handle result
        println!("Got: {:?}", result);
    }
    
    // Can bind with pattern matching
    Ok(data) = fallible_operation() => {
        process(data);
    }
    
    // Conditional branches with if guards
    msg = channel.recv(), if should_receive => {
        handle_message(msg);
    }
    
    // else branch for when all futures are disabled
    else => {
        println!("All branches disabled");
    }
}
;
Ok(())
}
fn main() {}
