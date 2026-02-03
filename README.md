# Todo API - C# ASP.NET Core

A simple REST API for managing todos built with ASP.NET Core Minimal API.

## Prerequisites

- .NET 10.0 SDK installed (`dotnet --version` to verify)
- Docker installed and running

## Run locally

```bash
dotnet run
```

The API will start on `http://localhost:8080`

## Test the API

### Linux / MacOS:

Automated:
```bash
./test-api.sh http://localhost:8080
```

Manually:
```bash
# Health check
curl http://localhost:8080/health

# Get all todos
curl http://localhost:8080/todos

# Create a todo
curl -X POST http://localhost:8080/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Docker"}'

# Update a todo
curl -X PUT http://localhost:8080/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed": true}'

# Delete a todo
curl -X DELETE http://localhost:8080/todos/1
```

### Windows

Automated:
```powershell
.\test-api.ps1 http://localhost:8080
```

Manually:
```powershell
# Health check
Invoke-RestMethod -Uri http://localhost:8080/health -Method Get

# Get all todos
Invoke-RestMethod -Uri http://localhost:8080/todos -Method Get

# Create a todo
$body = @{ title = "Learn Docker" } | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:8080/todos -Method Post -Body $body -ContentType "application/json"

# Update a todo
$body = @{ completed = $true } | ConvertTo-Json
Invoke-RestMethod -Uri http://localhost:8080/todos/1 -Method Put -Body $body -ContentType "application/json"

# Delete a todo
Invoke-RestMethod -Uri http://localhost:8080/todos/1 -Method Delete
```
