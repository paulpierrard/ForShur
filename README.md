👤 lucas – Product Service + CI

🎯 Responsable du micro-service Produits

Tâches

Création du Product Service

Node.js + PostgreSQL

Endpoint GET /products

Prisma (schema + migrations)

Dockerisation du service

CI Pipeline :

.github/workflows/ci-product-service.yml

Lint (ESLint)

Tests avec PostgreSQL container

Prisma migrate

CodeQL

Build & test Docker image

👤 Montajab – Order Service + CI

🎯 Responsable du micro-service Commandes

Tâches

Création du Order Service

Node.js + PostgreSQL

Endpoint GET /orders

Prisma (schema + migrations)

Dockerisation du service

CI Pipeline :

.github/workflows/ci-order-service.yml

Lint

Tests avec PostgreSQL container

Prisma migrate

CodeQL

Build & test Docker image

👤 Kavé – API Gateway + Frontend CI

🎯 Responsable de l’orchestration et de l’UI

Tâches

API Gateway

Node.js

Routing vers Product & Order services

CI Pipeline API Gateway :

.github/workflows/ci-api-gateway.yml

Frontend React

Liste des produits

Liste des commandes

CI Pipeline Frontend :

.github/workflows/ci-frontend.yml

Lint

Tests

CodeQL

Build & test Docker image

👤 Paul – 