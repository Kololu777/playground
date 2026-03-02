use std::env;
use std::process;

mod config;
mod utils;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <config-path>", args[0]);
        process::exit(1);
    }

    let config_path = &args[1];
    println!("Loading config from: {}", config_path);

    match config::load(config_path) {
        Ok(cfg) => {
            println!("App: {} v{}", cfg.name, cfg.version);
            println!("Debug mode: {}", cfg.debug);
        }
        Err(e) => {
            eprintln!("Failed to load config: {}", e);
            process::exit(1);
        }
    }
}
