# --- deps stage: install dependencies (bcrypt needs a C++ toolchain to build) ---
FROM node:22-alpine AS deps
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# --- runtime stage ---
FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN mkdir -p uploads invoices logs && chown -R node:node /app
USER node

EXPOSE 4444

CMD ["node", "index.js"]
