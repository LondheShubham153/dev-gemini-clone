##################################
# Stage 1: Build Stage
##################################
FROM node:18-alpine AS builder

# Add metadata for authorship and app identification
LABEL maintainer="Amitabh Soni <amitabhdevops2024@gmail.com>" \
      app="gemini" \
      stage="build"

WORKDIR /app

# Install build dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Clean up dev dependencies after build
RUN rm -rf node_modules && npm cache clean --force

##################################
# Stage 2: Production Stage
##################################
FROM node:18-alpine AS production

# Add metadata for the final image
LABEL maintainer="Amitabh Soni <amitabhdevops2024@gmail.com>" \
      app="gemini" \
      stage="production"

WORKDIR /app

# Install only production dependencies
COPY package.json package-lock.json* ./
RUN npm ci --production && npm cache clean --force

# Copy minimal required files
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./

# Set production environment
ENV NODE_ENV=production

EXPOSE 3000

CMD ["npm", "start"]