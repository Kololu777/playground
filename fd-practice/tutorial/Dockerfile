FROM node:20-slim AS builder

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --production=false

COPY tsconfig.json ./
COPY src/ ./src/
RUN npm run build

FROM node:20-slim

WORKDIR /app
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./

EXPOSE 3000

USER node
CMD ["node", "build/app/index.js"]
