#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
struct Bag<T>(Vec<T>);

impl<T> Bag<T> {
    fn new() -> Self { Bag(Vec::new()) }

    fn push(&mut self, item: T) { self.0.push(item); }

    fn len(&self) -> usize { self.0.len() }

    fn is_empty(&self) -> bool { self.0.is_empty() }
}

// 1. FromIterator — enables .collect::<Bag<T>>()
impl<T> FromIterator<T> for Bag<T> {
    fn from_iter<I: IntoIterator<Item = T>>(iter: I) -> Self {
        Bag(iter.into_iter().collect())
    }
}

// 2. Extend — enables .extend(iter) and is used internally by collect
impl<T> Extend<T> for Bag<T> {
    fn extend<I: IntoIterator<Item = T>>(&mut self, iter: I) {
        self.0.extend(iter);
    }
}

// 3a. IntoIterator for owned Bag (consuming)
impl<T> IntoIterator for Bag<T> {
    type Item = T;
    type IntoIter = std::vec::IntoIter<T>;

    fn into_iter(self) -> Self::IntoIter {
        self.0.into_iter()
    }
}

// 3b. IntoIterator for &Bag (borrowing)
impl<'a, T> IntoIterator for &'a Bag<T> {
    type Item = &'a T;
    type IntoIter = std::slice::Iter<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        self.0.iter()
    }
}

// 3c. IntoIterator for &mut Bag (mutable borrowing)
impl<'a, T> IntoIterator for &'a mut Bag<T> {
    type Item = &'a mut T;
    type IntoIter = std::slice::IterMut<'a, T>;

    fn into_iter(self) -> Self::IntoIter {
        self.0.iter_mut()
    }
}

fn main() {
    // collect works
    let b: Bag<i32> = [1, 2, 3].into_iter().collect();
    assert_eq!(b.len(), 3);

    // extend works
    let mut b2 = Bag::new();
    b2.extend([4, 5, 6]);
    assert_eq!(b2.len(), 3);

    // for loop works on &Bag
    for x in &b {
        let _ = x;
    }

    // map/filter chains work via IntoIterator
    let doubled: Bag<i32> = b.into_iter().map(|x| x * 2).collect();
    assert_eq!(doubled.len(), 3);
}
