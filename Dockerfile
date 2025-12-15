FROM node:22-alpine AS builder

RUN apk add --no-cache python3 make g++ git openssh

RUN corepack enable && corepack prepare pnpm@9.15.0 --activate

WORKDIR /app

COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build

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

WORKDIR /home/node

COPY --from=builder /app /home/node

ENV NODE_ENV=production \
    N8N_PORT=5678

EXPOSE 5678

WORKDIR /home/node/packages/cli

CMD ["node", "bin/n8n"]
