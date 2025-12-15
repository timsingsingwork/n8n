FROM node:22-alpine AS builder

RUN apk add --no-cache python3 make g++ git openssh

WORKDIR /app

COPY package.json package-lock.json* ./
COPY packages ./packages

RUN npm ci
RUN npm run build

FROM node:22-alpine

RUN apk add --no-cache \
    libxml2 \
    git \
    openssh \
    openssl \
    graphicsmagick \
    tini \
    tzdata \
    ca-certificates \
    libc6-compat

RUN npm install -g full-icu@1.5.0

WORKDIR /home/node

COPY --from=builder /app /home/node

ENV NODE_ENV=production \
    NODE_ICU_DATA=/usr/local/lib/node_modules/full-icu \
    N8N_PORT=5678

EXPOSE 5678

WORKDIR /home/node/packages/cli

CMD ["node", "bin/n8n"]
