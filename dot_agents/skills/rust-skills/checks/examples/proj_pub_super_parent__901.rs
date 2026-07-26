#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/parser/mod.rs
mod lexer;
mod ast;

#[cfg(test)]
mod tests {
    use super::*;
    
    // Test helper visible only to parser module's tests
    pub(super) fn make_test_token() -> Token {
        Token { kind: TokenKind::Test, span: Span::dummy() }
    }
}

// src/parser/lexer.rs
#[cfg(test)]
mod tests {
    use super::super::tests::make_test_token;
    // ...
}
fn main() {}
