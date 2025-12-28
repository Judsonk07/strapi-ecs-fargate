FROM node:20-alpine AS builder

WORKDIR /app

# Install build tools and curl for health checks
RUN apk add --no-cache curl python3 make g++

# Copy package files and install all dependencies (including devDependencies) for build
COPY package*.json ./
RUN npm ci

# Copy app source
COPY . .

# Build Strapi admin (REQUIRED)
RUN npm run build

FROM node:20-alpine
WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache curl

# Copy only production dependencies from builder
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built app and source
COPY --from=builder /app .

# Runtime env
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

EXPOSE 1337

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
  CMD curl -f http://localhost:1337 || exit 1

# Start Strapi
CMD ["npm", "run", "start"]
