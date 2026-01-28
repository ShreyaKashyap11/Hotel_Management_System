# Hotel Management System

This repository contains a minimal Hotel Management System with:

- Backend: Spring Boot (Java 21, Maven) — REST API for CRUD operations on hotels.
- Frontend: React (Vite) — UI to create, list, edit and delete hotels.
- Containerization: Dockerfiles for backend and frontend.
- Orchestration: Kubernetes manifests for each service (Deployment + Service).
- Local compose: `docker-compose.yml` for local dev.

## Project layout

- backend/ — Spring Boot app (Maven)
- frontend/ — React app (Vite)
- k8s/ — Kubernetes manifests (deployments + services)
- docker-compose.yml — compose file to run both locally

## Quick local steps (without Docker)
- Backend:
  - mvn -f backend clean package
  - java -jar backend/target/hotel-management-0.0.1-SNAPSHOT.jar
  - API base: http://localhost:8080/api/hotels
- Frontend:
  - cd frontend
  - npm install
  - npm run dev
  - Open the Vite dev URL (usually http://localhost:5173). To point to the backend when running dev, set VITE_API_BASE in `.env`.

## Run with Docker Compose
- Build and run:
  - docker compose build
  - docker compose up
- Frontend will be available at http://localhost:3000 and backend at http://localhost:8080

## Kubernetes (assumes images are built and pushed to a registry)
- Update images in `k8s/` manifests to your registry tags.
- Apply:
  - kubectl apply -f k8s/backend-deployment.yaml
  - kubectl apply -f k8s/frontend-deployment.yaml

## Create ZIP to push to GitHub
From the folder containing `backend/`, `frontend/`, `docker-compose.yml`, `k8s/`, run:

```bash
zip -r hotel-management.zip backend frontend docker-compose.yml k8s README.md
```

This will create `hotel-management.zip` you can upload to GitHub or extract locally.

