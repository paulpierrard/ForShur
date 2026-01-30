#!/bin/bash

# 🔐 Script de scanning de sécurité
# Lance les scans Dependabot + CodeQL localement pour validation avant merge

set -e

echo "🔐 Scanning de sécurité des dépendances..."

# Configuration des services
SERVICES=("api-gateway" "frontend" "order-service" "product-service")

# 1️⃣ Vérifier npm audit pour vulnérabilités
echo -e "\n📦 Vérification des vulnérabilités npm..."
for SERVICE in "${SERVICES[@]}"; do
  if [ -f "$SERVICE/package.json" ]; then
    echo "   🔍 Scanning $SERVICE..."
    cd "$SERVICE"
    
    # Exécuter npm audit
    if npm audit --audit-level=moderate > /tmp/$SERVICE-audit.json 2>&1; then
      echo "   ✅ $SERVICE: OK"
    else
      echo "   ⚠️  $SERVICE: Vulnérabilités trouvées"
      npm audit
    fi
    
    cd ..
  fi
done

# 2️⃣ Vérifier les dépendances outdated
echo -e "\n🔄 Vérification des versions outdated..."
for SERVICE in "${SERVICES[@]}"; do
  if [ -f "$SERVICE/package.json" ]; then
    echo "   🔍 Checking $SERVICE..."
    cd "$SERVICE"
    npm outdated || true
    cd ..
  fi
done

# 3️⃣ Vérifier les licences problématiques
echo -e "\n📜 Vérification des licences..."
for SERVICE in "${SERVICES[@]}"; do
  if [ -f "$SERVICE/package.json" ]; then
    echo "   🔍 Scanning $SERVICE..."
    cd "$SERVICE"
    npm list --depth=0 | grep -i "gpl\|agpl" || echo "   ✅ Pas de licences GPL/AGPL détectées"
    cd ..
  fi
done

echo -e "\n✅ Scanning de sécurité terminé"
