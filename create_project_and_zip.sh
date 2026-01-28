#!/usr/bin/env bash
set -euo pipefail

echo "Creating project files..."
# Create directories
mkdir -p backend/src/main/java/com/example/hotelmanagement/model
mkdir -p backend/src/main/java/com/example/hotelmanagement/repository
mkdir -p backend/src/main/java/com/example/hotelmanagement/service
mkdir -p backend/src/main/java/com/example/hotelmanagement/controller
mkdir -p backend/src/main/resources

mkdir -p frontend/src/components
mkdir -p frontend/src
mkdir -p k8s

# backend/pom.xml
cat > backend/pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.example</groupId>
  <artifactId>hotel-management</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>jar</packaging>

  <name>hotel-management</name>

  <properties>
    <java.version>21</java.version>
    <spring.boot.version>3.2.0</spring.boot.version>
    <maven.compiler.release>${java.version}</maven.compiler.release>
  </properties>

  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>${spring.boot.version}</version>
    <relativePath/>
  </parent>

  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
    </dependency>

    <!-- For easier JSON handling -->
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
    </dependency>

    <!-- Optional: Lombok (comment out if not desired) -->
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <optional>true</optional>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
          <excludes>
            <exclude>
              <groupId>org.projectlombok</groupId>
              <artifactId>lombok</artifactId>
            </exclude>
          </excludes>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
EOF

# backend main application
cat > backend/src/main/java/com/example/hotelmanagement/HotelManagementApplication.java <<'EOF'
package com.example.hotelmanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HotelManagementApplication {
    public static void main(String[] args) {
        SpringApplication.run(HotelManagementApplication.class, args);
    }
}
EOF

# backend model
cat > backend/src/main/java/com/example/hotelmanagement/model/Hotel.java <<'EOF'
package com.example.hotelmanagement.model;

import jakarta.persistence.*;

@Entity
@Table(name = "hotels")
public class Hotel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    private Double rating;
    private Integer roomsAvailable;
    private Double pricePerNight;

    public Hotel() {}

    public Hotel(String name, String address, Double rating, Integer roomsAvailable, Double pricePerNight) {
        this.name = name;
        this.address = address;
        this.rating = rating;
        this.roomsAvailable = roomsAvailable;
        this.pricePerNight = pricePerNight;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Integer getRoomsAvailable() { return roomsAvailable; }
    public void setRoomsAvailable(Integer roomsAvailable) { this.roomsAvailable = roomsAvailable; }

    public Double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(Double pricePerNight) { this.pricePerNight = pricePerNight; }
}
EOF

# backend repository
cat > backend/src/main/java/com/example/hotelmanagement/repository/HotelRepository.java <<'EOF'
package com.example.hotelmanagement.repository;

import com.example.hotelmanagement.model.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long> {
}
EOF

# backend service
cat > backend/src/main/java/com/example/hotelmanagement/service/HotelService.java <<'EOF'
package com.example.hotelmanagement.service;

import com.example.hotelmanagement.model.Hotel;
import com.example.hotelmanagement.repository.HotelRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HotelService {
    private final HotelRepository repo;

    public HotelService(HotelRepository repo) {
        this.repo = repo;
    }

    public List<Hotel> findAll() {
        return repo.findAll();
    }

    public Optional<Hotel> findById(Long id) {
        return repo.findById(id);
    }

    public Hotel create(Hotel hotel) {
        hotel.setId(null);
        return repo.save(hotel);
    }

    public Optional<Hotel> update(Long id, Hotel newHotel) {
        return repo.findById(id).map(h -> {
            h.setName(newHotel.getName());
            h.setAddress(newHotel.getAddress());
            h.setRating(newHotel.getRating());
            h.setRoomsAvailable(newHotel.getRoomsAvailable());
            h.setPricePerNight(newHotel.getPricePerNight());
            return repo.save(h);
        });
    }

    public boolean delete(Long id) {
        return repo.findById(id).map(h -> {
            repo.delete(h);
            return true;
        }).orElse(false);
    }
}
EOF

# backend controller
cat > backend/src/main/java/com/example/hotelmanagement/controller/HotelController.java <<'EOF'
package com.example.hotelmanagement.controller;

import com.example.hotelmanagement.model.Hotel;
import com.example.hotelmanagement.service.HotelService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/hotels")
@CrossOrigin(origins = "*")
public class HotelController {
    private final HotelService service;

    public HotelController(HotelService service) {
        this.service = service;
    }

    @GetMapping
    public List<Hotel> getAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getById(@PathVariable Long id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Hotel> create(@RequestBody Hotel hotel) {
        Hotel created = service.create(hotel);
        return ResponseEntity.created(URI.create("/api/hotels/" + created.getId())).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Hotel> update(@PathVariable Long id, @RequestBody Hotel hotel) {
        return service.update(id, hotel)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        boolean deleted = service.delete(id);
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}
EOF

# backend application.properties
cat > backend/src/main/resources/application.properties <<'EOF'
server.port=8080

spring.datasource.url=jdbc:h2:mem:hotelsdb;DB_CLOSE_DELAY=-1
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.hibernate.ddl-auto=update
spring.h2.console.enabled=true
EOF

# backend Dockerfile and dockerignore
cat > backend/Dockerfile <<'EOF'
# Build stage
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

# Run stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/hotel-management-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
EOF

cat > backend/.dockerignore <<'EOF'
target
.git
.idea
.vscode
EOF

# k8s backend manifest
cat > k8s/backend-deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hotel-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hotel-backend
  template:
    metadata:
      labels:
        app: hotel-backend
    spec:
      containers:
        - name: hotel-backend
          image: hotel-backend:latest
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hotel-backend
spec:
  type: ClusterIP
  selector:
    app: hotel-backend
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
EOF

# frontend package.json
cat > frontend/package.json <<'EOF'
{
  "name": "hotel-frontend",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "axios": "^1.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0"
  }
}
EOF

# frontend index.html
cat > frontend/index.html <<'EOF'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>Hotel Management</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# frontend main.jsx
cat > frontend/src/main.jsx <<'EOF'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./styles.css";

createRoot(document.getElementById("root")).render(<App />);
EOF

# frontend App.jsx
cat > frontend/src/App.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import api from "./api";
import HotelForm from "./components/HotelForm";

function App() {
  const [hotels, setHotels] = useState([]);
  const [editing, setEditing] = useState(null);

  const load = async () => {
    const res = await api.get("/hotels");
    setHotels(res.data);
  };

  useEffect(() => {
    load();
  }, []);

  const handleDelete = async (id) => {
    await api.delete(`/hotels/${id}`);
    setHotels(hotels.filter(h => h.id !== id));
  };

  const handleEdit = (hotel) => {
    setEditing(hotel);
  };

  const onSaved = (saved) => {
    if (editing) {
      setHotels(hotels.map(h => (h.id === saved.id ? saved : h)));
    } else {
      setHotels([saved, ...hotels]);
    }
    setEditing(null);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Hotel Management</h1>
      <HotelForm editing={editing} onSaved={onSaved} />
      <hr />
      <h2>Hotels</h2>
      <table border="1" cellPadding="6" style={{ borderCollapse: "collapse", width: "100%" }}>
        <thead>
          <tr>
            <th>Name</th>
            <th>Address</th>
            <th>Rating</th>
            <th>Rooms</th>
            <th>Price</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {hotels.map(h => (
            <tr key={h.id}>
              <td>{h.name}</td>
              <td>{h.address}</td>
              <td>{h.rating}</td>
              <td>{h.roomsAvailable}</td>
              <td>{h.pricePerNight}</td>
              <td>
                <button onClick={() => handleEdit(h)}>Edit</button>{" "}
                <button onClick={() => handleDelete(h.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;
EOF

# frontend api.js
cat > frontend/src/api.js <<'EOF'
import axios from "axios";

const API_BASE = import.meta.env.VITE_API_BASE || "http://localhost:8080/api";

const api = axios.create({
  baseURL: `${API_BASE}`,
  headers: { "Content-Type": "application/json" },
});

export default api;
EOF

# frontend HotelForm.jsx
cat > frontend/src/components/HotelForm.jsx <<'EOF'
import React, { useEffect, useState } from "react";
import api from "../api";

export default function HotelForm({ editing, onSaved }) {
  const [form, setForm] = useState({
    name: "",
    address: "",
    rating: 0,
    roomsAvailable: 0,
    pricePerNight: 0
  });

  useEffect(() => {
    if (editing) setForm(editing);
    else setForm({ name: "", address: "", rating: 0, roomsAvailable: 0, pricePerNight: 0 });
  }, [editing]);

  const handleChange = e => {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]: value }));
  };

  const submit = async (e) => {
    e.preventDefault();
    if (editing && editing.id) {
      const res = await api.put(`/hotels/${editing.id}`, form);
      onSaved(res.data);
    } else {
      const res = await api.post("/hotels", form);
      onSaved(res.data);
    }
  };

  return (
    <form onSubmit={submit} style={{ marginBottom: 16 }}>
      <input name="name" placeholder="Name" value={form.name} onChange={handleChange} required />
      <input name="address" placeholder="Address" value={form.address} onChange={handleChange} required />
      <input name="rating" placeholder="Rating" value={form.rating} onChange={handleChange} type="number" step="0.1" />
      <input name="roomsAvailable" placeholder="Rooms" value={form.roomsAvailable} onChange={handleChange} type="number" />
      <input name="pricePerNight" placeholder="Price" value={form.pricePerNight} onChange={handleChange} type="number" step="0.01" />
      <button type="submit">{editing ? "Update" : "Create"}</button>
    </form>
  );
}
EOF

# frontend styles.css
cat > frontend/src/styles.css <<'EOF'
body {
  font-family: Arial, Helvetica, sans-serif;
  margin: 0;
  padding: 0;
}
input {
  margin-right: 8px;
  padding: 4px;
}
button {
  padding: 4px 8px;
}
EOF

# frontend Dockerfile and dockerignore
cat > frontend/Dockerfile <<'EOF'
# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .
RUN npm run build

# Serve stage
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > frontend/.dockerignore <<'EOF'
node_modules
dist
.git
EOF

# k8s frontend manifest
cat > k8s/frontend-deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hotel-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hotel-frontend
  template:
    metadata:
      labels:
        app: hotel-frontend
    spec:
      containers:
        - name: hotel-frontend
          image: hotel-frontend:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: hotel-frontend
spec:
  type: ClusterIP
  selector:
    app: hotel-frontend
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
EOF

# docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: "3.8"
services:
  backend:
    build: ./backend
    image: hotel-backend:local
    ports:
      - "8080:8080"
    networks:
      - hotel-net

  frontend:
    build: ./frontend
    image: hotel-frontend:local
    ports:
      - "3000:80"
    environment:
      - VITE_API_BASE=http://localhost:8080/api
    networks:
      - hotel-net

networks:
  hotel-net:
    driver: bridge
EOF

# README.md (use 4-backtick code block in the file so it's preserved if displayed somewhere that expects it)
cat > README.md <<'EOF'
````markdown
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