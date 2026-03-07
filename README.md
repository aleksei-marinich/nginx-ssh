zz# MyApp

## 📋 Описание
Проект на Docker с Nginx и поддержкой SSH через HTTPS (порт 443).

## 🚀 Быстрый старт

### Локальная разработка
```bash
# Клонируем репозиторий
git clone <your-repo-url>
cd myapp

# Настраиваем окружение
cp .env.example .env
# Отредактируйте .env под свои нужды

# Запускаем
docker compose up -d