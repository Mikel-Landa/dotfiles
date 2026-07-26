#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::rc::{Rc, Weak};
use std::cell::RefCell;

struct Node {
    parent: RefCell<Weak<Node>>,        // back-reference: does not own the parent
    children: RefCell<Vec<Rc<Node>>>,
}

let parent = Rc::new(Node {
    parent: RefCell::new(Weak::new()),
    children: RefCell::new(vec![]),
});
let child = Rc::new(Node {
    parent: RefCell::new(Rc::downgrade(&parent)),
    children: RefCell::new(vec![]),
});
parent.children.borrow_mut().push(Rc::clone(&child));

// upgrade() yields Option<Rc<Node>> — None once the parent is dropped
let _maybe_parent: Option<Rc<Node>> = child.parent.borrow().upgrade();
;
Ok(())
}
fn main() {}
