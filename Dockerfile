############################
# -----  Builder  -------- #
############################
FROM node:20-alpine AS builder
WORKDIR /app

# Full install (may trigger postinstall)
COPY package*.json ./
RUN npm ci

# Compile
COPY . .
RUN npm run build

############################
# -----  Runtime  -------- #
############################
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

# Prod-only deps (no dev postinstall scripts)
COPY package*.json ./
RUN npm ci --omit=dev

# 4️Ship the compiled output
COPY --from=builder /app/dist ./dist

ENV SSE_ADDR=0.0.0.0:3000
EXPOSE 3000
CMD ["node", "dist/index.js"]
