# Nginx Router for Docker Applications

This setup configures an Nginx reverse proxy to route traffic to three different applications running in Docker containers:

1. Frontend application (main site)
2. Frontend page application
3. Backend API

## Configuration

The routing is based on URL paths:
- `/` - Routes to the main frontend application
- `/page/` - Routes to the frontend page application
- `/api/` - Routes to the backend API

This Docker Compose setup contains **only the Nginx router**, and assumes your application containers are deployed separately on the same Docker network.

## Environment Variables

You can customize the configuration by creating a `.env` file with the following variables:

```
# Nginx configuration
NGINX_PORT=80

# Application container names and ports
FRONTEND_CONTAINER=frontend
FRONTEND_PORT=3000

FRONTEND_PAGE_CONTAINER=frontend-page
FRONTEND_PAGE_PORT=3001

BACKEND_API_CONTAINER=backend-api
BACKEND_API_PORT=8000
```

## Usage

1. Create a `.env` file with the above variables configured for your environment.

2. Make sure your application containers are running and on the same Docker network named `app-network`.

3. Start the Nginx router:
   ```
   docker-compose up -d
   ```

4. Access your applications:
   - Main frontend: http://localhost
   - Frontend page: http://localhost/page/
   - Backend API: http://localhost/api/

## Notes

- This configuration uses Docker container names for routing instead of domains.
- You must create the external Docker network `app-network` before deploying this router:
  ```
  docker network create app-network
  ```
- Ensure all your application containers are connected to this network.
- The Nginx router will forward requests to the appropriate container based on the URL path. 