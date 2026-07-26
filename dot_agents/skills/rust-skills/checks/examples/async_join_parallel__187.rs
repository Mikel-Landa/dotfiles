#![allow(unused, dead_code, unreachable_code, unused_imports, unused_variables, unused_mut, unused_assignments, unused_macros, non_local_definitions)]
async fn __ex() -> Result<(), Box<dyn std::error::Error>> {
use tokio::join;

async fn fetch_data() -> (User, Posts, Comments) {
    // Concurrent: ~100ms total (max of all three)
    let (user, posts, comments) = join!(
        fetch_user(),
        fetch_posts(),
        fetch_comments(),
    );
    
    (user, posts, comments)
}

use tokio::try_join;

async fn read_configs() -> Result<(Config, Settings)> {
    // Concurrent: ~20ms total
    let (config_str, settings_str) = try_join!(
        fs::read_to_string("config.toml"),
        fs::read_to_string("settings.json"),
    )?;
    
    Ok((parse_config(&config_str)?, parse_settings(&settings_str)?))
}
;
Ok(())
}
fn main() {}
