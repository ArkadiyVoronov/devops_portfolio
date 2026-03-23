# docker/web/Dockerfile (оптимизированный)
FROM nginx:alpine AS builder

# Установка только необходимых пакетов
RUN apk add --no-cache \
    curl \
    wget \
    && rm -rf /var/cache/apk/*

# Многоэтапная сборка
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/nginx /usr/share/nginx
COPY --from=builder /etc/nginx /etc/nginx

# Минимальный пользователь
USER 1001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD [ "wget", "--quiet", "--tries=1", "--spider", "http://localhost/" ]

CMD ["nginx", "-g", "daemon off;"]
