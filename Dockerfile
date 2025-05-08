##########################
# ────── Builder ─────── #
##########################
FROM node:22.12-alpine AS builder

# 1. App source (everything *except* files ignored by .dockerignore)
WORKDIR /app
COPY . .

# 2. Install all deps without running post-install scripts
#    The cache mount keeps the layer fast on rebuilds
RUN --mount=type=cache,target=/root/.npm \
    npm install --ignore-scripts

# 3. Compile TypeScript → dist/
RUN npx tsc

##########################
# ────── Runtime ─────── #
##########################
FROM node:22-alpine AS release
WORKDIR /app
ENV NODE_ENV=production

# 4. Copy only the dependency manifests
COPY package.json package-lock.json ./

# 5. Install *production-only* deps, still skipping scripts
RUN --mount=type=cache,target=/root/.npm \
    npm install --omit=dev --ignore-scripts

# 6. Bring in the compiled output
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"]
