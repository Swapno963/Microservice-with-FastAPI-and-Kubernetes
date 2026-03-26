.PHONY: build run test clean deploy logs scale

IMAGE_NAME = product-service
IMAGE_TAG = v1.0
REPLICAS = 2

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

run:
	docker run -d -p 8000:8000 --name $(IMAGE_NAME) $(IMAGE_NAME):$(IMAGE_TAG)

test:
	@echo "Testing health endpoint..."
	curl -f http://localhost:8000/health || exit 1
	@echo "\nCreating a product..."
	curl -X POST http://localhost:8000/products \
		-H "Content-Type: application/json" \
		-d '{"name":"Laptop","description":"Gaming laptop","price":999.99,"stock":10}'
	@echo "\nListing products..."
	curl http://localhost:8000/products

stop:
	docker stop $(IMAGE_NAME) || true
	docker rm $(IMAGE_NAME) || true

clean: stop
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true

deploy:
	kubectl apply -f k8s/

delete-deploy:
	kubectl delete -f k8s/

logs:
	kubectl logs -l app=product-service --tail=100 -f

scale:
	kubectl scale deployment product-service --replicas=$(REPLICAS)

status:
	@echo "Pods:"
	kubectl get pods -l app=product-service
	@echo "\nServices:"
	kubectl get svc product-service

