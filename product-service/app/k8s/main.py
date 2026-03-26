from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from . import models, database

app = FastAPI(
    title="Product Catalog Service",
    description="A microservice for managing product inventory",
    version="1.0.0"
)

# Health check endpoint
@app.get("/health")
def health_check():
    return {"status": "healthy"}

# Create product
@app.post("/products", response_model=models.Product, status_code=status.HTTP_201_CREATED)
def create_product(
    product: models.ProductCreate,
    db: Session = Depends(database.get_db)
):
    db_product = database.ProductDB(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product

# Get all products
@app.get("/products", response_model=List[models.Product])
def get_products(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(database.get_db)
):
    products = db.query(database.ProductDB).offset(skip).limit(limit).all()
    return products

# Get single product
@app.get("/products/{product_id}", response_model=models.Product)
def get_product(
    product_id: int,
    db: Session = Depends(database.get_db)
):
    product = db.query(database.ProductDB).filter(database.ProductDB.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

# Update product
@app.put("/products/{product_id}", response_model=models.Product)
def update_product(
    product_id: int,
    product_update: models.ProductUpdate,
    db: Session = Depends(database.get_db)
):
    product = db.query(database.ProductDB).filter(database.ProductDB.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")

    update_data = product_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(product, key, value)

    db.commit()
    db.refresh(product)
    return product

# Delete product
@app.delete("/products/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_product(
    product_id: int,
    db: Session = Depends(database.get_db)
):
    product = db.query(database.ProductDB).filter(database.ProductDB.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")

    db.delete(product)
    db.commit()
    return None

