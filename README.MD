
# Product Catalog Microservice

## 🚀 Overview

This project implements a **Product Catalog microservice** using FastAPI, designed for modern cloud-native deployments. It provides CRUD operations for product data with RESTful endpoints, optimized for **scalability, observability, and maintainability**.

**Problem Solved:**

* Enables product management in distributed systems with minimal latency.
* Demonstrates end-to-end DevOps practices: containerization, Kubernetes orchestration, horizontal scaling, and automation.

**Why this architecture:**

* **Microservice isolation:** Product service is decoupled, allowing independent scaling and deployment.
* **Kubernetes deployment:** Ensures high availability and load balancing with minimal operational overhead.
* **Automation-first:** Makefile-driven workflows enforce reproducibility and developer efficiency.

---

## 🏗️ Architecture

```
[Client/Browser]
       ↓
[Load Balancer] (VPC Level)
       ↓
[Kubernetes Service] (ClusterIP)
       ↓
[Product Service Pods] (2+ replicas)
       ↓
[SQLite Database] (Persistent Volume)
```

**Components & Interactions:**

* **Client → LoadBalancer:** External requests are routed to the cluster.
* **K8s Service (ClusterIP):** Internal abstraction for routing traffic to pods.
* **Product Service Pods:** Handle API requests, perform business logic, and interact with the database.
* **Persistent Database Volume:** Ensures data durability even if pods restart or reschedule.

**Design Trade-offs:**

* **SQLite over Postgres:** Simplified local development and demonstration; for production, switching to a clustered DB is recommended.
* **2+ replicas:** Balances availability and resource usage; horizontal scaling tested up to 3 replicas.
* **ClusterIP internal service:** Promotes internal load balancing without exposing pods directly, reducing attack surface.

---

## ⚙️ Tech Stack

**Backend:**

* FastAPI – Python-based microservices framework
* SQLAlchemy – ORM for relational data management
* Pydantic – Data validation

**Infrastructure & DevOps:**

* Docker – Containerization (multi-stage builds)
* Kubernetes – Orchestration & scaling
* Persistent Volumes – Data durability

**Automation & CI/CD:**

* Makefile – Task automation for build, deploy, test, scale, and cleanup
* YAML – Declarative Kubernetes manifests

**Monitoring & Debugging:**

* `kubectl` & pod logs for operational visibility

---

## 📦 Services / Components

* **Product Service:**

  * CRUD endpoints for products
  * Health-check endpoint for readiness and liveness probes
  * Interacts with a SQLite database via SQLAlchemy

* **Kubernetes Deployment:**

  * `deployment.yaml` defines pod replicas, container image, and resource limits
  * `service.yaml` exposes the pods internally via ClusterIP

* **LoadBalancer Service:**

  * Exposes service externally at the VPC/network level (`loadbalancer.yaml`)
  * Enables direct testing from outside the cluster

---

## 🔄 Request Flow

1. Client sends HTTP request to LoadBalancer.
2. LoadBalancer forwards traffic to Kubernetes Service (ClusterIP).
3. K8s Service routes request to one of the Product Service Pods.
4. Pod processes request:

   * Validates request via Pydantic
   * Interacts with SQLite via SQLAlchemy
   * Returns response to client
5. LoadBalancer responds back to the client.

**Observation:** Horizontal scaling distributes requests across multiple pods to improve throughput and resilience.

---

## 🛠️ Setup & Installation

```bash
# Clone repository
git clone <repo-url>
cd product-service

# Build Docker image
docker build -t product-service:v1.0 .

# Run locally
docker run -p 8000:8000 product-service:v1.0

# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/loadbalancer.yaml

# Verify deployment
kubectl get pods
kubectl get svc
```

**Makefile Automation:**

```bash
make build        # Build Docker image
make run          # Run container locally
make test         # Execute curl endpoint tests
make deploy       # Deploy to Kubernetes
make delete-deploy# Cleanup deployment
make scale        # Scale replicas to 3
make status       # Check pod and service status
make logs         # View pod logs
make clean        # Remove images and temp artifacts
```

---

## 🧪 Key DevOps Concepts Demonstrated

* **Containerization:** Multi-stage Docker builds, clean image layering
* **Orchestration:** Kubernetes deployments, services, and LoadBalancer exposure
* **Networking:** ClusterIP for internal routing, LoadBalancer for external access
* **Automation:** Makefile-driven workflows for reproducible environments
* **Horizontal Scaling:** Pod replicas to handle load spikes
* **Observability:** Logs and health-check endpoints for proactive monitoring

---

## 🔐 Production Considerations

* **Security:** Restrict database access to pods; LoadBalancer only exposes API endpoints
* **Scaling:** Replace SQLite with distributed DB for concurrent writes; auto-scaling based on CPU/memory
* **Observability:** Integrate Prometheus/Grafana for metrics; central logging with ELK or Loki
* **Failure Handling:** Readiness/liveness probes, pod anti-affinity for high availability

---

## 🚧 Challenges & Learnings

* **Kubernetes pod scheduling:** Initial deployment failed due to missing persistent volume; resolved by defining PV and PVC correctly.
* **Database concurrency:** SQLite works for demo; recognized need for a production-grade DB for write-heavy workloads.
* **Makefile orchestration:** Learned how to encapsulate build, deploy, scale, and logging in a single file for reproducibility.

---

## 📌 Future Improvements

* Swap SQLite with PostgreSQL or MySQL with replication for high availability
* Implement CI/CD pipelines for automated testing and deployment
* Add API rate-limiting, authentication, and authorization
* Introduce caching (Redis) to reduce DB load
* Integrate centralized monitoring and alerting for production readiness

---

## 📸 Diagram (ASCII)

```
          ┌────────────┐
          │  Client    │
          └─────┬──────┘
                │
          ┌─────▼──────┐
          │ LoadBalancer│
          └─────┬──────┘
                │
      ┌─────────▼─────────┐
      │Kubernetes Service  │
      └─────┬─────────────┘
            │
      ┌─────▼─────┐
      │ Product   │
      │ Service   │
      │ Pods (2+) │
      └─────┬─────┘
            │
      ┌─────▼─────┐
      │ SQLite DB │
      │(Persistent│
      │ Volume)   │
      └───────────┘
```

---

This README highlights your **DevOps thinking, production awareness, and system-level reasoning**, making it strong for both **technical recruiters** and **senior engineers** reviewing your profile.

---

If you want, I can also **add a “Production-ready Notes” section with exact K8s YAML snippets and scaling commands** to show advanced deployment skills directly in the README, which will make it even more resume-ready. Do you want me to do that?
