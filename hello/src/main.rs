use lambda::lambda;
use serde_json::Value;
use tokio;

type Error = Box<dyn std::error::Error + Send + Sync + 'static>;

#[lambda]
#[tokio::main]
async fn main(event: Value) -> Result<Value, Error> {
    println!("HELLO");
    Ok(event)
}
