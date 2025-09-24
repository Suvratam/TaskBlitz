# Stage 1: Build
FROM node:22-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY count-app/package.json count-app/package-lock.json ./
RUN npm ci

# Copy the rest of the source code
COPY count-app/ .

# Build the app
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy build output to Nginx html folder
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

