#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
#[test]
fn search_returns_matching_documents() {
    // Arrange
    let mut index = SearchIndex::new();
    index.add_document(Document::new(1, "rust programming"));
    index.add_document(Document::new(2, "python programming"));
    index.add_document(Document::new(3, "rust web development"));
    
    let query = Query::new("rust");
    
    // Act
    let results = index.search(&query);
    
    // Assert
    assert_eq!(results.len(), 2);
    assert!(results.iter().any(|d| d.id == 1));
    assert!(results.iter().any(|d| d.id == 3));
}
;
Ok(())
}
fn main() {}
