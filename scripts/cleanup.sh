# scripts/cleanup.sh
#!/bin/bash

# Очистка Docker
docker system prune -af --volumes

# Проверка размера контейнеров
echo "=== Docker Images Size ==="
docker images --format "table {{.Repository}}\t{{.Size}}" | sort -hr -k2

# Проверка занимаемого места
echo "=== Directory Sizes ==="
du -sh ansible/ terraform/ docker/ tests/ | sort -hr

# Ограничение размера образов
MAX_IMAGE_SIZE=50M
for image in $(docker images -q); do
    size=$(docker inspect -f '{{.Size}}' $image)
    if [ $size -gt $MAX_IMAGE_SIZE ]; then
        echo "Warning: Large image detected: $image ($((size/1024/1024))MB)"
    fi
done
