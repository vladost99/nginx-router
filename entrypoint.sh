#!/bin/sh
set -e

# Replace environment variables in nginx.conf
envsubst '${FRONTEND_CONTAINER} ${FRONTEND_PORT} ${FRONTEND_PAGE_CONTAINER} ${FRONTEND_PAGE_PORT} ${BACKEND_API_CONTAINER} ${BACKEND_API_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Nginx configuration file has been prepared with environment variables."

exit 0 