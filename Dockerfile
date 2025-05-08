FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

# Compile TypeScript -> dist/…
RUN npm run build

# ── critical line ──
ENV SSE_ADDR=0.0.0.0:3000

EXPOSE 3000
CMD ["node", "dist/index.js"]
