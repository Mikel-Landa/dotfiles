#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use std::io::{BufWriter, Write};

fn write_many_records(records: &[Record], mut output: impl Write) -> std::io::Result<()> {
    // BufWriter reuses its internal buffer
    let mut writer = BufWriter::with_capacity(8192, &mut output);
    let mut line = String::with_capacity(256);  // Reusable formatting buffer
    
    for record in records {
        line.clear();
        format_record(record, &mut line);
        writer.write_all(line.as_bytes())?;
        writer.write_all(b"\n")?;
    }
    
    writer.flush()
}
;
Ok(())
}
fn main() {}
