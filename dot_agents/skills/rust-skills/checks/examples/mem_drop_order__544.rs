#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
fn process() {
    let conn = open_connection();   // dropped third (last to drop)
    let txn  = begin_transaction(); // dropped second
    let guard = acquire_lock();     // dropped first — WRONG if txn needs the lock

    // fix: drop guard explicitly before txn and conn drop naturally
    do_work(&txn);
    drop(guard); // lock released here
    txn.commit(); // runs before conn closes
} // conn drops here
# fn open_connection() -> () {}
# fn begin_transaction() -> () {}
# fn acquire_lock() -> () {}
# fn do_work(_: &()) {}
# trait Commit { fn commit(self); }
# impl Commit for () { fn commit(self) {} }
;
Ok(())
}
fn main() {}
