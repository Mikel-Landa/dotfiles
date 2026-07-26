#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
struct RequestBuilder {
    url: String,
    timeout: Option<Duration>,
    headers: Vec<(String, String)>,
}

struct Request;

impl Request {
    fn builder(url: impl Into<String>) -> RequestBuilder {
        RequestBuilder {
            url: url.into(),
            timeout: None,
            headers: Vec::new(),
        }
    }
}

impl RequestBuilder {
    #[must_use = "builder methods return modified builder - chain or assign"]
    fn timeout(mut self, duration: Duration) -> Self {
        self.timeout = Some(duration);
        self
    }
    
    #[must_use = "builder methods return modified builder - chain or assign"]
    fn header(mut self, key: &str, value: &str) -> Self {
        self.headers.push((key.to_string(), value.to_string()));
        self
    }

    fn build(self) -> Request {
        Request
    }
}

// Now warns: unused return value that must be used
let request = Request::builder("https://api.example.com");
request.timeout(Duration::from_secs(30));  // Warning!

// Correct: chain methods
let request = Request::builder("https://api.example.com")
    .timeout(Duration::from_secs(30))
    .header("Authorization", "Bearer token")
    .build();
;
Ok(())
}
fn main() {}
