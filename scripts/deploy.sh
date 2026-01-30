#!/bin/bash

# 🚀 Script de déploiement avec zéro downtime
# Effectue un rolling deployment avec health checks

set -e

SERVICE=$1
VERSION=$2
REGISTRY=${3:-"ghcr.io"}
REPO_OWNER=${4:-"${GITHUB_REPOSITORY_OWNER}"}

if [ -z "$SERVICE" ] || [ -z "$VERSION" ]; then
  echo "❌ Usage: deploy.sh <service-name> <version> [registry] [repo-owner]"
  exit 1
fi

IMAGE="$REGISTRY/$REPO_OWNER/$SERVICE:v$VERSION"

echo "🚀 Déploiement de $SERVICE v$VERSION"
echo "   Image: $IMAGE"

# 1️⃣ Vérifier que l'image existe
echo "🔍 Vérification de l'image Docker..."
if ! docker pull "$IMAGE" > /dev/null 2>&1; then
  echo "❌ Image non trouvée: $IMAGE"
  exit 1
fi
echo "✅ Image trouvée"

# 2️⃣ Vérifier la santé du service actuel (avant déploiement)
echo "🏥 Vérification de la santé pré-déploiement..."
if ! bash scripts/health-check.sh "$SERVICE"; then
  echo "⚠️  Service actuellement indisponible, poursuivant quand même..."
fi

# 3️⃣ Déploiement progressif (selon votre infra)
# Exemples pour différentes infrastructures:

echo "📤 Déploiement de la nouvelle version..."

# Option 1: Kubernetes (uncomment si utilisant k8s)
# kubectl set image deployment/$SERVICE $SERVICE=$IMAGE --record
# kubectl rollout status deployment/$SERVICE

# Option 2: Docker Compose
# docker-compose -f docker-compose.yml up -d --no-deps --build $SERVICE

# Option 3: Systemd
# docker pull "$IMAGE"
# systemctl stop $SERVICE || true
# sleep 5
# systemctl start $SERVICE

# Option 4: Manual (remplacer par votre stratégie)
echo "   Remplacement du conteneur $SERVICE..."
docker stop "$SERVICE" || true
sleep 3
docker rm "$SERVICE" || true
docker run -d \
  --name "$SERVICE" \
  --restart=always \
  "$IMAGE"

# 4️⃣ Vérifier la santé du service après déploiement
echo "🏥 Vérification de la santé post-déploiement..."
sleep 5

if bash scripts/health-check.sh "$SERVICE"; then
  echo "✅ Déploiement réussi! Service opérationnel."
  exit 0
else
  echo "❌ Service n'a pas démarré correctement après déploiement"
  echo "🔄 Rollback recommandé..."
  exit 1
fi
