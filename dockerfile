FROM node:20-alpine

WORKDIR /app

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

# Start Strapi
CMD ["npm", "run" , "start"]
