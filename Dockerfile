FROM nginx:alpine

# Копіюємо конфігураційні файли
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh

# Надаємо права на виконання скрипту
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Створюємо власний скрипт запуску
RUN echo '#!/bin/sh' > /usr/local/bin/start-nginx.sh && \
    echo '/usr/local/bin/custom-entrypoint.sh' >> /usr/local/bin/start-nginx.sh && \
    echo 'exec nginx-debug -g "daemon off;"' >> /usr/local/bin/start-nginx.sh && \
    chmod +x /usr/local/bin/start-nginx.sh

# Використовуємо наш скрипт як команду запуску
CMD ["/usr/local/bin/start-nginx.sh"] 