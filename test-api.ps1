# Simple script to test the Todo API
# Usage: .\test-api.ps1 [base-url]
# Example: .\test-api.ps1 http://localhost:8080

param(
    [string]$BaseUrl = "http://localhost:8080"
)

Write-Host "`nTesting Todo API at $BaseUrl" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Write-Host "`n1. Health Check:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/health" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n2. Get welcome message:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n3. Get empty todos:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n4. Create first todo:" -ForegroundColor Yellow
try {
    $body = @{
        title = "Learn Docker"
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n5. Create second todo:" -ForegroundColor Yellow
try {
    $body = @{
        title = "Deploy to Azure"
        completed = $false
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n6. Create third todo:" -ForegroundColor Yellow
try {
    $body = @{
        title = "Master Kubernetes"
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n7. Get all todos:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n8. Update todo (mark as completed):" -ForegroundColor Yellow
try {
    $body = @{
        completed = $true
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos/1" -Method Put -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n9. Update todo (change title and mark completed):" -ForegroundColor Yellow
try {
    $body = @{
        title = "Successfully deployed to Azure!"
        completed = $true
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos/2" -Method Put -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n10. Get all todos (after updates):" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n11. Delete todo:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos/3" -Method Delete -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n12. Get remaining todos:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "❌ Failed: $_" -ForegroundColor Red
}

Write-Host "`n`n13. Try to create todo without title (should fail):" -ForegroundColor Yellow
try {
    $body = @{
        completed = $false
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos" -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Expected error (400 Bad Request):" -ForegroundColor Magenta
    Write-Host $_.Exception.Message -ForegroundColor Magenta
}

Write-Host "`n`n14. Try to delete non-existent todo (should fail):" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/todos/999" -Method Delete -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Expected error (404 Not Found):" -ForegroundColor Magenta
    Write-Host $_.Exception.Message -ForegroundColor Magenta
}

Write-Host "`n`n✅ Test complete!" -ForegroundColor Green
