#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// Accepts Vec<u8>, [u8; N], &mut [u8] — any type that lends &mut [u8]
fn fill_zeros(mut buf: impl AsMut<[u8]>) {
    for b in buf.as_mut().iter_mut() {
        *b = 0;
    }
}

fn verify(mut buf: impl AsMut<[u8]>) -> bool {
    buf.as_mut().iter().all(|&b| b == 0)
}

fn main() {
    let mut vec_buf = vec![1u8, 2, 3];
    fill_zeros(&mut vec_buf);
    assert!(verify(&mut vec_buf));

    let mut arr_buf = [1u8, 2, 3, 4];
    fill_zeros(&mut arr_buf);
    assert!(verify(&mut arr_buf));

    let mut slice_buf = [5u8, 6, 7];
    fill_zeros(slice_buf.as_mut());
    assert!(verify(slice_buf.as_mut()));
}
