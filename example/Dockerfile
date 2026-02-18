# Use NGINX as the base image, use alpine for size gains
FROM nginx:1.23-alpine

# Copy built web files to container
COPY ./build/web /usr/share/nginx/html

# Copy nginx.conf with WASM MIME to nginx conf location
COPY ./nginx.conf /etc/nginx/nginx.conf

# The NGINX container exposes port 80 by default
# and starts automatically, so there's no need
# to specify an entrypoint or command.