# Health check
curl http://$SERVICE_IP/health

# Create products
curl -X POST http://$SERVICE_IP/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Laptop",
    "description": "High-performance laptop",
    "price": 1299.99,
    "stock": 15
  }'

curl -X POST http://$SERVICE_IP/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mouse",
    "description": "Wireless gaming mouse",
    "price": 79.99,
    "stock": 50
  }'

# Get all products
curl http://$SERVICE_IP/products | jq

# Get specific product (use ID from previous response)
curl http://$SERVICE_IP/products/1 | jq

# Update product
curl -X PUT http://$SERVICE_IP/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "price": 1199.99,
    "stock": 12
  }' | jq

# Delete product
curl -X DELETE http://$SERVICE_IP/products/2

# Verify deletion
curl http://$SERVICE_IP/products | jq

