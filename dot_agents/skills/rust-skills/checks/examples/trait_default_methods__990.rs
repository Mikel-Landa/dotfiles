#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
trait Summarise {
    // ----- Required: the only thing implementors must provide -----
    fn sentences(&self) -> Vec<String>;

    // ----- Defaulted: free for all implementors -----
    fn first_sentence(&self) -> Option<String> {
        self.sentences().into_iter().next()
    }

    fn word_count(&self) -> usize {
        self.sentences().join(" ").split_whitespace().count()
    }

    fn is_empty(&self) -> bool {
        self.sentences().is_empty()
    }
}

// Minimal impl — one method, three come for free.
struct Article { body: String }

impl Summarise for Article {
    fn sentences(&self) -> Vec<String> {
        self.body
            .split('.')
            .map(str::trim)
            .filter(|s| !s.is_empty())
            .map(str::to_owned)
            .collect()
    }
}

// Override a default for performance when the default is provably slower.
struct PreSplit { parts: Vec<String> }

impl Summarise for PreSplit {
    fn sentences(&self) -> Vec<String> {
        self.parts.clone()
    }

    // Override: the parts are already split — no need to join and re-split.
    fn word_count(&self) -> usize {
        self.parts.iter().flat_map(|s| s.split_whitespace()).count()
    }
}

fn print_summary(item: &impl Summarise) {
    if item.is_empty() {
        println!("(empty)");
        return;
    }
    if let Some(first) = item.first_sentence() {
        println!("first: {first}");
    }
    println!("words: {}", item.word_count());
}

fn demo() {
    let a = Article { body: "Rust is fast. Rust is safe. Rust is fun.".to_owned() };
    print_summary(&a);

    let p = PreSplit { parts: vec!["hello world".to_owned(), "foo bar baz".to_owned()] };
    print_summary(&p);
}
;
Ok(())
}
fn main() {}
