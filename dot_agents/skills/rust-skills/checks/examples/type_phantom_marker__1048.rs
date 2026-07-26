#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::marker::PhantomData;

// States as zero-size types
struct Unlocked;
struct Locked;

struct Door<State> {
    _state: PhantomData<State>,
}

impl Door<Unlocked> {
    fn lock(self) -> Door<Locked> {
        println!("Locking...");
        Door { _state: PhantomData }
    }
    
    fn open(&self) {
        println!("Opening...");
    }
}

impl Door<Locked> {
    fn unlock(self) -> Door<Unlocked> {
        println!("Unlocking...");
        Door { _state: PhantomData }
    }
    
    // Can't call open() on Locked door - method doesn't exist
}

fn example() {
    let door: Door<Unlocked> = Door { _state: PhantomData };
    door.open();           // OK
    let locked = door.lock();
    // locked.open();      // Error: no method `open` for Door<Locked>
    let unlocked = locked.unlock();
    unlocked.open();       // OK
}
;
Ok(())
}
fn main() {}
