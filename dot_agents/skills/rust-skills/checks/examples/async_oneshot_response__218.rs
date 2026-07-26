#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
// Standardize request-response pattern
struct RpcRequest<Req, Res> {
    request: Req,
    reply: oneshot::Sender<Res>,
}

impl<Req, Res> RpcRequest<Req, Res> {
    fn new(request: Req) -> (Self, oneshot::Receiver<Res>) {
        let (tx, rx) = oneshot::channel();
        (RpcRequest { request, reply: tx }, rx)
    }
    
    fn respond(self, response: Res) {
        let _ = self.reply.send(response);
    }
}

// Usage
let (req, rx) = RpcRequest::new(GetUser { id: 42 });
tx.send(req).await?;
let user = rx.await?;
;
Ok(())
}
fn main() {}
