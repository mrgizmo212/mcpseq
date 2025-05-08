FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci            # installs dev & prod deps

COPY . .

# Compile TypeScript -> dist/…
RUN npm run build     # assumes "build": "tsc"

# ── critical line ──
ENV SSE_ADDR=0.0.0.0:3000   # tells the server to start in SSE mode

EXPOSE 3000
CMD ["node", "dist/index.js"]
