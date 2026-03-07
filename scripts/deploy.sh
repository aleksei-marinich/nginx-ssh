#!/bin/bash

echo "🚀 Начинаем деплой..."

# Создаем необходимые директории
mkdir -p www

# Создаем тестовую страницу
cat > www/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>SSH Proxy</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        h1 { color: #333; }
        .success { color: green; font-size: 24px; }
    </style>
</head>
<body>
    <h1>🔌 SSH Proxy Server</h1>
    <p class="success">✅ Nginx работает!</p>
    <p>Сервер готов к SSH подключениям на порту 443</p>
    <p>IP: <span id="ip"></span></p>
    <script>
        fetch('https://api.ipify.org?format=json')
            .then(r => r.json())
            .then(d => document.getElementById('ip').textContent = d.ip);
    </script>
</body>
</html>
EOF

# Останавливаем старые контейнеры
echo "🛑 Останавливаем старые контейнеры..."
docker compose down 2>/dev/null || true

# Запускаем новый контейнер
echo "🐳 Запускаем Nginx прокси..."
docker compose up -d

# Проверяем статус
echo "📊 Статус:"
docker compose ps

# Ждем немного и проверяем логи
sleep 3
echo "📋 Логи:"
docker compose logs --tail=20

echo "✅ Деплой завершен!"
echo "🌐 HTTP: http://$(curl -s ifconfig.me)"
echo "🔌 SSH: ssh -p 443 $(whoami)@$(curl -s ifconfig.me)"