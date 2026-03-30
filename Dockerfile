FROM node:20-bookworm-slim AS base

WORKDIR /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./


FROM base AS development-deps

ENV NODE_ENV=development

RUN npm ci


FROM development-deps AS development

COPY . .


FROM development AS build

RUN npm run build


FROM base AS production-deps

ENV NODE_ENV=production

RUN npm ci --omit=dev && npm cache clean --force


FROM node:20-bookworm-slim AS production

WORKDIR /app
ENV NODE_ENV=production

COPY --from=production-deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package.json ./package.json
COPY --from=build --chown=node:node /app/package-lock.json ./package-lock.json
COPY --from=build --chown=node:node /app/.sequelizerc ./.sequelizerc
COPY --from=build --chown=node:node /app/config ./config
COPY --from=build --chown=node:node /app/server ./server
COPY --from=build --chown=node:node /app/dist ./dist

EXPOSE 8080

USER node

CMD ["npm", "run", "start"]
