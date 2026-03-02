/**
 * Application module - TypeScript example
 */

// TODO: Replace console.log with a proper logger

export const APP_NAME = "ripgrep-practice";
export const APP_VERSION = "1.0.0";

export interface User {
  id: number;
  name: string;
  email: string;
  role: "admin" | "user" | "guest";
}

export function greetUser(user: User): string {
  console.log(`Greeting user: ${user.name}`);
  return `Hello, ${user.name}! Welcome to ${APP_NAME}.`;
}

export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export const createUser = (
  name: string,
  email: string,
  role: User["role"] = "user"
): User => {
  console.log(`Creating user: ${name}`);
  return {
    id: Math.floor(Math.random() * 10000),
    name,
    email,
    role,
  };
};

function formatUserList(users: User[]): string {
  console.log(`Formatting ${users.length} users`);
  return users.map((u) => `${u.name} (${u.role})`).join(", ");
}

export default formatUserList;
