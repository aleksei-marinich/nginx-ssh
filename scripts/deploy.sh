#!/bin/bash
# Скрипт для деплоя на сервер

set -e  # Останавливаем при ошибке

echo "🚀 Начинаем деплой..."

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверяем наличие .env файла
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env файл не найден, копируем из .env.example${NC}"
    cp .env.example .env
    echo -e "${RED}❗ Отредактируйте .env файл перед деплоем!${NC}"
    exit 1
fi

# Загружаем переменные
source .env

echo -e "${GREEN}✅ Переменные окружения загружены${NC}"

# Создаем необходимые директории на сервере (если нет)
echo "📁 Создаем директории на сервере..."
mkdir -p nginx/ssl www

# Копируем простую тестовую страницу
cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>MyApp</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        h1 { color: #333; }
        .success { color: green; }
    </style>
</head>
<body>
    <h1>🚀 MyApp</h1>
    <p class="success">✅ Nginx работает!</p>
    <p>Сервер: <span id="hostname"></span></p>
    <script>
        document.getElementById('hostname').textContent = window.location.hostname;
    </script>
</body>
</html>
EOF

echo -e "${GREEN}✅ Тестовая страница создана${NC}"

# Запускаем контейнеры
echo "🐳 Запускаем Docker контейнеры..."
docker compose down 2>/dev/null || true
docker compose up -d --build

# Проверяем статус
echo -e "${GREEN}✅ Контейнеры запущены${NC}"
docker compose ps

# Проверяем логи
echo -e "${YELLOW}📋 Последние логи:${NC}"
docker compose logs --tail=20

echo -e "${GREEN}🎉 Деплой завершен!${NC}"
echo -e "🌐 Сайт: http://${SERVER_IP:-localhost}"
echo -e "🔌 SSH: ssh -p 443 ${SERVER_USER:-root}@${SERVER_IP:-localhost}"