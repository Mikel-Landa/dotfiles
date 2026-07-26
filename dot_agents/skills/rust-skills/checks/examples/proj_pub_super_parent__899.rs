#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/parser/mod.rs
pub mod lexer;
pub mod ast;

// Shared types for parser submodules only
pub(super) struct Token {
    pub(super) kind: TokenKind,
    pub(super) span: Span,
}

pub(super) fn shared_helper() -> Token {
    // Only visible in parser/*
}

// src/parser/lexer.rs
use super::{Token, shared_helper};

pub fn lex(input: &str) -> Vec<Token> {
    shared_helper();
    // ...
}

// src/parser/ast.rs
use super::Token;

pub fn parse(tokens: Vec<Token>) -> Ast {
    // ...
}
fn main() {}
