#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::mem;

#[derive(Debug)]
enum State {
    Idle,
    Loading { url: String },
    Done { body: String },
}

impl Default for State {
    fn default() -> Self {
        State::Idle
    }
}

struct Machine {
    state: State,
}

impl Machine {
    fn start_load(&mut self, url: String) {
        // replace Idle with Loading, getting Idle back (discarded here)
        let _prev = mem::replace(&mut self.state, State::Loading { url });
    }

    fn complete(&mut self, body: String) {
        // replace Loading with Done; capture old state if needed for logging
        match mem::replace(&mut self.state, State::Done { body }) {
            State::Loading { url } => {
                println!("finished loading {url}");
            }
            other => {
                // unexpected transition — put it back or handle the error
                self.state = other;
            }
        }
    }
}
;
Ok(())
}
fn main() {}
