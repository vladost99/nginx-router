FROM nginx:alpine

# Переконаємося, що стандартна конфігурація не заважатиме
RUN rm -f /etc/nginx/conf.d/default.conf

# Копіюємо нашу конфігурацію
COPY nginx.conf /etc/nginx/nginx.conf.template

# Установлюємо envsubst, якщо він не встановлений (але зазвичай він є)
RUN which envsubst || apk add --no-cache gettext

# Створюємо скрипт для заміни змінних і запуску nginx
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'echo "Starting Nginx configuration with environment variables..."' >> /docker-entrypoint.sh && \
    echo 'echo "Substituting environment variables in nginx.conf..."' >> /docker-entrypoint.sh && \
    echo 'envsubst "\${FRONTEND_CONTAINER} \${FRONTEND_PORT} \${FRONTEND_PAGE_CONTAINER} \${FRONTEND_PAGE_PORT} \${BACKEND_API_CONTAINER} \${BACKEND_API_PORT}" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'echo "===== Generated Nginx Config ====="' >> /docker-entrypoint.sh && \
    echo 'cat /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'echo "=================================="' >> /docker-entrypoint.sh && \
    echo 'echo "Starting Nginx..."' >> /docker-entrypoint.sh && \
    echo 'exec nginx-debug -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Заупускаємо наш скрипт
ENTRYPOINT ["/docker-entrypoint.sh"] 