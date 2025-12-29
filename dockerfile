FROM node:20-alpine

WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy package files
COPY package*.json ./

# Install ALL dependencies (required for build)
RUN npm install --production

# Copy app source
COPY . .

# Build Strapi admin (REQUIRED)
RUN npm run build

# Runtime env
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

EXPOSE 1337

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
  CMD curl -f http://localhost:1337 || exit 1

# Start Strapi
CMD ["npm", "run" , "start"]
