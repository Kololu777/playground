# API Reference

## Endpoints

### GET /health

Returns the server health status.

**Response:**
```json
{ "status": "ok", "uptime": 12345 }
```

### GET /api/users

Returns a list of all users. Requires authentication.

**Headers:**
- `Authorization: Bearer <token>`

**Response:**
```json
[
  { "id": 1, "name": "Alice", "role": "admin" },
  { "id": 2, "name": "Bob", "role": "user" }
]
```

### POST /api/login

Authenticates a user and returns a JWT token.

**Body:**
```json
{ "email": "user@example.com", "password": "secret" }
```
