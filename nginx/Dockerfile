FROM nginx:latest

# Устанавливаем openssl для генерации сертификатов
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Копируем конфигурацию
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем директорию для сертификатов
RUN mkdir -p /etc/nginx/ssl

# Скрипт для генерации самоподписанного сертификата при первом запуске
COPY generate-ssl.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/generate-ssl.sh

EXPOSE 80 443