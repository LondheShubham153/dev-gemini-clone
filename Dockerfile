##################################
# Stage 1: Build Stage
##################################
FROM node:18-alpine AS builder

WORKDIR /app

# Define build argument for the API key
ARG NEXT_PUBLIC_API_KEY
# Set the environment variable for the build process
ENV NEXT_PUBLIC_API_KEY=$NEXT_PUBLIC_API_KEY

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the code and build Next.js
COPY . .
RUN npm run build

##################################
# Stage 2: Production Stage
##################################
FROM node:18-alpine

WORKDIR /app

# Copy everything from the builder stage
# COPY --from=builder /app ./

# or 

# Copy only the necessary files
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./


EXPOSE 3000

CMD ["npm", "start"]
