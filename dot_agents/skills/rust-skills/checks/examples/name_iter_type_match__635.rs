#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
mod my_collection {
    pub struct MyCollection<T> {
        items: Vec<T>,
    }
    
    // Iterator types in same module
    pub struct Iter<'a, T> {
        inner: std::slice::Iter<'a, T>,
    }
    
    pub struct IterMut<'a, T> {
        inner: std::slice::IterMut<'a, T>,
    }
    
    pub struct IntoIter<T> {
        inner: std::vec::IntoIter<T>,
    }
    
    impl<T> MyCollection<T> {
        pub fn iter(&self) -> Iter<'_, T> {
            Iter { inner: self.items.iter() }
        }
        
        pub fn iter_mut(&mut self) -> IterMut<'_, T> {
            IterMut { inner: self.items.iter_mut() }
        }
    }
    
    impl<T> IntoIterator for MyCollection<T> {
        type Item = T;
        type IntoIter = IntoIter<T>;
        
        fn into_iter(self) -> IntoIter<T> {
            IntoIter { inner: self.items.into_iter() }
        }
    }
    
    // Implement Iterator for each type
    impl<'a, T> Iterator for Iter<'a, T> {
        type Item = &'a T;
        fn next(&mut self) -> Option<Self::Item> {
            self.inner.next()
        }
    }
    
    impl<'a, T> Iterator for IterMut<'a, T> {
        type Item = &'a mut T;
        fn next(&mut self) -> Option<Self::Item> {
            self.inner.next()
        }
    }
    
    impl<T> Iterator for IntoIter<T> {
        type Item = T;
        fn next(&mut self) -> Option<Self::Item> {
            self.inner.next()
        }
    }
}
fn main() {}
