FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .

# Build TS -> JS
RUN npm run build          # assumes "build": "tsc"

EXPOSE 3000                # same port everywhere
CMD ["node", "dist/index.js"]
