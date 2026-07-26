#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
// src/lib.rs
mod parser;
mod lexer;
mod ast;

// src/parser.rs
pub fn parse(input: &str) -> Result<Ast, Error> {
    let tokens = tokenize(input)?;
    build_ast(tokens)
}

fn tokenize(input: &str) -> Result<Vec<Token>, Error> { ... }
fn build_ast(tokens: Vec<Token>) -> Result<Ast, Error> { ... }

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_parse_simple() {
        let ast = parse("1 + 2").unwrap();
        assert_eq!(ast.evaluate(), 3);
    }
    
    #[test]
    fn test_tokenize() {
        let tokens = tokenize("1 + 2").unwrap();
        assert_eq!(tokens.len(), 3);
    }
}
fn main() {}
