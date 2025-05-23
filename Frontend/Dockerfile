# Use Node.js base image
FROM node:22.16-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose Vite's default dev server port
EXPOSE 5173

# Enable polling for file changes (useful in Docker)
ENV CHOKIDAR_USEPOLLING=true

# Start Vite dev server
CMD ["npm", "run", "dev"]