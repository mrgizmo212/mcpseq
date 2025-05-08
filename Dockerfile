##########################
# ────── Builder ─────── #
##########################
FROM node:22.12-alpine AS builder
WORKDIR /app

COPY . .

# install without post-install scripts
RUN npm install --ignore-scripts

# compile
RUN npx tsc

##########################
# ────── Runtime ─────── #
##########################
FROM node:22-alpine AS release
WORKDIR /app
ENV NODE_ENV=production

COPY package.json package-lock.json ./
RUN npm install --omit=dev --ignore-scripts

COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"]
