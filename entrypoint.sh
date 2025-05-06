#!/bin/sh
set -e

echo "Starting Nginx configuration with environment variables..."

# List all environment variables for debugging
echo "Environment variables:"
env | grep -E "FRONTEND|BACKEND"

# Replace environment variables in nginx.conf
echo "Substituting environment variables in nginx.conf..."
envsubst '${FRONTEND_CONTAINER} ${FRONTEND_PORT} ${FRONTEND_PAGE_CONTAINER} ${FRONTEND_PAGE_PORT} ${BACKEND_API_CONTAINER} ${BACKEND_API_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# For debugging: show that we actually substituted variables
echo "===== Nginx Config with Substituted Variables ====="
cat /etc/nginx/nginx.conf
echo "=================================================="

echo "Nginx configuration file has been prepared with environment variables."

# Ensure script exits successfully
exit 0 