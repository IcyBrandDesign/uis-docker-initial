#!/bin/bash

# Simple script to test the Todo API
# Usage: ./test-api.sh [base-url]
# Example: ./test-api.sh http://localhost:8080

BASE_URL=${1:-http://localhost:8080}

echo "Testing Todo API at $BASE_URL"
echo "================================"

echo -e "\n1. Health Check:"
curl -s $BASE_URL/health | python3 -m json.tool

echo -e "\n\n2. Get welcome message:"
curl -s $BASE_URL/ | python3 -m json.tool

echo -e "\n\n3. Get empty todos:"
curl -s $BASE_URL/todos | python3 -m json.tool

echo -e "\n\n4. Create first todo:"
curl -s -X POST $BASE_URL/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Docker"}' | python3 -m json.tool

echo -e "\n\n5. Create second todo:"
curl -s -X POST $BASE_URL/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Deploy to Azure", "completed": false}' | python3 -m json.tool

echo -e "\n\n6. Create third todo:"
curl -s -X POST $BASE_URL/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Master Kubernetes"}' | python3 -m json.tool

echo -e "\n\n7. Get all todos:"
curl -s $BASE_URL/todos | python3 -m json.tool

echo -e "\n\n8. Update todo (mark as completed):"
curl -s -X PUT $BASE_URL/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed": true}' | python3 -m json.tool

echo -e "\n\n9. Update todo (change title and mark completed):"
curl -s -X PUT $BASE_URL/todos/2 \
  -H "Content-Type: application/json" \
  -d '{"title": "Successfully deployed to Azure!", "completed": true}' | python3 -m json.tool

echo -e "\n\n10. Get all todos (after updates):"
curl -s $BASE_URL/todos | python3 -m json.tool

echo -e "\n\n11. Delete todo:"
curl -s -X DELETE $BASE_URL/todos/3 | python3 -m json.tool

echo -e "\n\n12. Get remaining todos:"
curl -s $BASE_URL/todos | python3 -m json.tool

echo -e "\n\n13. Try to create todo without title (should fail):"
curl -s -X POST $BASE_URL/todos \
  -H "Content-Type: application/json" \
  -d '{"completed": false}' | python3 -m json.tool

echo -e "\n\n14. Try to get non-existent todo (should fail):"
curl -s -X DELETE $BASE_URL/todos/999 | python3 -m json.tool

echo -e "\n\n✅ Test complete!"
