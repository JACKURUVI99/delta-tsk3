# Simple Dockerfile for Lua chat server
FROM alpine:latest

# Install Lua and required packages
RUN apk add --no-cache lua5.3 lua5.3-socket lua5.3-dev

# Create app directory
WORKDIR /app

# Copy application files
COPY server.lua .
COPY simple_json.lua .

# Create data directory for persistent storage
RUN mkdir -p /app/data

# Expose port
EXPOSE 8888

# Run the server
CMD ["lua5.3", "server.lua"]