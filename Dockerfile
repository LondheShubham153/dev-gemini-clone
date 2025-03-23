##################################
# Stage 1: Build Stage
##################################

# Use the official Node.js 18 image as the base image
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package files and install all dependencies (including dev)
COPY package*.json ./
RUN npm install

# Copy the remaining application code and build the app
COPY . .
RUN npm run build

# Remove development dependencies to reduce image size
# RUN npm prune --production


##################################
# Stage 2: Production Stage
##################################

# Use the official Node.js 18 image as the base image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy built files and production dependencies from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
