#!/bin/bash
# scripts/healthcheck.sh - Проверка здоровья всех сервисов

echo "🔍 Проверка состояния сервисов..."
echo "================================"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Проверяем каждый контейнер
for service in nginx app db; do
    if docker compose ps $service | grep -q "Up"; then
        echo -e "${GREEN}✅ $service: работает${NC}"
    else
        echo -e "${RED}❌ $service: не работает${NC}"
    fi
done

echo -e "\n🌐 Проверка HTTP доступности:"
if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q "200\|304"; then
    echo -e "${GREEN}✅ HTTP: доступен${NC}"
else
    echo -e "${RED}❌ HTTP: не доступен${NC}"
fi

echo -e "\n🔌 Проверка портов:"
for port in 22 80 443; do
    if ss -tlnp | grep -q ":$port"; then
        echo -e "${GREEN}✅ Порт $port: слушается${NC}"
    else
        echo -e "${RED}❌ Порт $port: не слушается${NC}"
    fi
done

echo -e "\n💾 Использование ресурсов:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"