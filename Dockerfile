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
    echo 'echo "Environment variables:"' >> /docker-entrypoint.sh && \
    echo 'env | grep -E "FRONTEND|BACKEND"' >> /docker-entrypoint.sh && \
    echo 'echo "Substituting environment variables in nginx.conf..."' >> /docker-entrypoint.sh && \
    echo 'envsubst "\${FRONTEND_CONTAINER} \${FRONTEND_PORT} \${FRONTEND_PAGE_CONTAINER} \${FRONTEND_PAGE_PORT} \${BACKEND_API_CONTAINER} \${BACKEND_API_PORT}" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'echo "===== Generated Nginx Config ====="' >> /docker-entrypoint.sh && \
    echo 'cat /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'echo "=================================="' >> /docker-entrypoint.sh && \
    echo 'echo "Setting up logging to stdout..."' >> /docker-entrypoint.sh && \
    echo 'mkdir -p /var/log/nginx' >> /docker-entrypoint.sh && \
    echo 'ln -sf /dev/stdout /var/log/nginx/access.log' >> /docker-entrypoint.sh && \
    echo 'ln -sf /dev/stderr /var/log/nginx/error.log' >> /docker-entrypoint.sh && \
    echo 'echo "Testing network connectivity..."' >> /docker-entrypoint.sh && \
    echo 'if [ -n "$FRONTEND_CONTAINER" ]; then' >> /docker-entrypoint.sh && \
    echo '  echo "Testing ping to $FRONTEND_CONTAINER..."' >> /docker-entrypoint.sh && \
    echo '  ping -c 1 $FRONTEND_CONTAINER || echo "WARNING: Cannot ping $FRONTEND_CONTAINER"' >> /docker-entrypoint.sh && \
    echo 'fi' >> /docker-entrypoint.sh && \
    echo 'if [ -n "$FRONTEND_PAGE_CONTAINER" ]; then' >> /docker-entrypoint.sh && \
    echo '  echo "Testing ping to $FRONTEND_PAGE_CONTAINER..."' >> /docker-entrypoint.sh && \
    echo '  ping -c 1 $FRONTEND_PAGE_CONTAINER || echo "WARNING: Cannot ping $FRONTEND_PAGE_CONTAINER"' >> /docker-entrypoint.sh && \
    echo 'fi' >> /docker-entrypoint.sh && \
    echo 'if [ -n "$BACKEND_API_CONTAINER" ]; then' >> /docker-entrypoint.sh && \
    echo '  echo "Testing ping to $BACKEND_API_CONTAINER..."' >> /docker-entrypoint.sh && \
    echo '  ping -c 1 $BACKEND_API_CONTAINER || echo "WARNING: Cannot ping $BACKEND_API_CONTAINER"' >> /docker-entrypoint.sh && \
    echo 'fi' >> /docker-entrypoint.sh && \
    echo 'echo "Starting Nginx with extended debug logging..."' >> /docker-entrypoint.sh && \
    echo 'exec nginx-debug -g "daemon off; error_log /dev/stderr debug;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Заупускаємо наш скрипт
ENTRYPOINT ["/docker-entrypoint.sh"] 