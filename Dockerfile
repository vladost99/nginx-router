FROM nginx:alpine

# Копіюємо конфігураційні файли
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY entrypoint.sh /docker-entrypoint.d/40-envsubst-config.sh

# Надаємо права на виконання скрипту
RUN chmod +x /docker-entrypoint.d/40-envsubst-config.sh

# Запускаємо Nginx з детальним логуванням
CMD ["nginx-debug", "-g", "daemon off;"] 