using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

// Configure to listen on all interfaces
builder.WebHost.UseUrls("http://0.0.0.0:8080");

var app = builder.Build();

// In-memory storage
var todos = new List<Todo>();
var nextId = 1;

// Health check
app.MapGet("/health", () => new
{
    status = "healthy",
    timestamp = DateTime.UtcNow
});

// Welcome endpoint
app.MapGet("/", () => new
{
    message = "Welcome to Todo API!",
    endpoints = new Dictionary<string, string>
    {
        { "GET /health", "Health check" },
        { "GET /todos", "List all todos" },
        { "POST /todos", "Create a todo (requires: title)" },
        { "PUT /todos/:id", "Update a todo" },
        { "DELETE /todos/:id", "Delete a todo" }
    }
});

// Get all todos
app.MapGet("/todos", () => new
{
    todos,
    count = todos.Count
});

// Create todo
app.MapPost("/todos", (TodoRequest request) =>
{
    if (string.IsNullOrWhiteSpace(request.Title))
    {
        return Results.BadRequest(new { error = "Title is required" });
    }

    var todo = new Todo
    {
        Id = nextId++,
        Title = request.Title,
        Completed = request.Completed,
        CreatedAt = DateTime.UtcNow
    };

    todos.Add(todo);
    return Results.Created($"/todos/{todo.Id}", todo);
});

// Update todo
app.MapPut("/todos/{id}", (int id, TodoUpdate update) =>
{
    var todo = todos.FirstOrDefault(t => t.Id == id);
    
    if (todo == null)
    {
        return Results.NotFound(new { error = "Todo not found" });
    }

    if (!string.IsNullOrWhiteSpace(update.Title))
    {
        todo.Title = update.Title;
    }

    if (update.Completed.HasValue)
    {
        todo.Completed = update.Completed.Value;
    }

    return Results.Ok(todo);
});

// Delete todo
app.MapDelete("/todos/{id}", (int id) =>
{
    var todo = todos.FirstOrDefault(t => t.Id == id);
    
    if (todo == null)
    {
        return Results.NotFound(new { error = "Todo not found" });
    }

    todos.Remove(todo);
    return Results.Ok(new { message = "Todo deleted", id });
});

app.Run();

// Models
record Todo
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public bool Completed { get; set; }
    public DateTime CreatedAt { get; set; }
}

record TodoRequest(string Title, bool Completed = false);

record TodoUpdate(string? Title, bool? Completed);
