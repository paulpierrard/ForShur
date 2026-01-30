#!/bin/bash

# 📊 Script de vérification de santé du service
# Utilisé dans le pipeline CD pour le zero downtime deployment

set -e

SERVICE=$1
MAX_RETRIES=5
RETRY_DELAY=10
TIMEOUT=30

if [ -z "$SERVICE" ]; then
  echo "❌ Usage: health-check.sh <service-name>"
  exit 1
fi

# Déterminer le port du service
case "$SERVICE" in
  api-gateway)
    PORT=3000
    HEALTH_PATH="/health"
    ;;
  product-service)
    PORT=3001
    HEALTH_PATH="/health"
    ;;
  order-service)
    PORT=3002
    HEALTH_PATH="/health"
    ;;
  frontend)
    PORT=3000
    HEALTH_PATH="/"
    ;;
  *)
    echo "❌ Service inconnu: $SERVICE"
    exit 1
    ;;
esac

echo "🔍 Vérification de la santé du service: $SERVICE (port $PORT)"

# Boucle de retry
for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "   Tentative $i/$MAX_RETRIES..."

  if curl -sf --max-time $TIMEOUT "http://localhost:$PORT$HEALTH_PATH" > /dev/null 2>&1; then
    echo "✅ Service $SERVICE est opérationnel!"
    exit 0
  fi

  if [ $i -lt $MAX_RETRIES ]; then
    echo "   ⏳ Attente de ${RETRY_DELAY}s avant nouvelle tentative..."
    sleep $RETRY_DELAY
  fi
done

echo "❌ Service $SERVICE n'a pas répondu après $MAX_RETRIES tentatives"
exit 1
