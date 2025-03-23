##################################
# Stage 1: Build Stage
##################################
FROM node:18-alpine AS builder

WORKDIR /app

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
COPY --from=builder /app ./

EXPOSE 3000

CMD ["npm", "start"]
