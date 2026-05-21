# Stage 1: Build the application
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install
# RUN npm ci
COPY . .

RUN npm run build

# Xóa devDependencies để giảm dung lượng
RUN npm prune --production

# Stage 2: Run the application
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

USER node

EXPOSE 3000

CMD ["npm", "dist/index.js"]