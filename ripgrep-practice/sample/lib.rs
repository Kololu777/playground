/// Sample Rust library module

// TODO: Implement Display trait for all structs

/// A user in the system
struct User {
    name: String,
    email: String,
    age: u32,
}

/// Configuration for the application
struct AppConfig {
    name: String,
    version: String,
    debug: bool,
    max_connections: u32,
}

impl User {
    /// Create a new user
    fn new(name: &str, email: &str, age: u32) -> Self {
        User {
            name: name.to_string(),
            email: email.to_string(),
            age,
        }
    }

    /// Get the user's display name
    fn display_name(&self) -> String {
        format!("{} <{}>", self.name, self.email)
    }

    /// Check if the user is an adult
    fn is_adult(&self) -> bool {
        self.age >= 18
    }
}

impl AppConfig {
    fn default() -> Self {
        AppConfig {
            name: "ripgrep-practice".to_string(),
            version: "0.1.0".to_string(),
            debug: false,
            max_connections: 100,
        }
    }
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

fn fibonacci(n: u32) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => {
            let mut a: u64 = 0;
            let mut b: u64 = 1;
            for _ in 2..=n {
                let temp = b;
                b = a + b;
                a = temp;
            }
            b
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn test_fibonacci() {
        assert_eq!(fibonacci(10), 55);
    }

    #[test]
    fn test_user_display() {
        let user = User::new("Alice", "alice@example.com", 30);
        assert_eq!(user.display_name(), "Alice <alice@example.com>");
    }
}
