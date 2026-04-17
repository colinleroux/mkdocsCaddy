FROM python:3.12-slim AS builder

WORKDIR /app

RUN pip install --no-cache-dir mkdocs mkdocs-material

COPY mkdocs.yml .
COPY docs ./docs

RUN mkdocs build --clean

FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /app/site /srv

EXPOSE 10005
