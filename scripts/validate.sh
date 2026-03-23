# scripts/validate.sh
#!/bin/bash

set -e

echo "=== Validation Check ==="

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не установлен"
    exit 1
fi

# Проверка Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose не установлен"
    exit 1
fi

# Проверка синтаксиса YAML
echo "Проверка YAML файлов..."
yamllint .

# Проверка Docker Compose файлов
for compose_file in $(find . -name "docker-compose*.yml"); do
    docker-compose -f $compose_file config > /dev/null
    if [ $? -eq 0 ]; then
        echo "OK: $compose_file"
    else
        echo "ERROR: $compose_file"
        exit 1
    fi
done

# Проверка запуска контейнеров
echo "Тестирование запуска контейнеров..."
docker-compose -f docker/web/docker-compose.yml up -d --build
sleep 10
if docker ps | grep -q "web"; then
    echo "Web контейнер работает"
else
    echo "Web контейнер не запущен"
    exit 1
fi

# Очистка
docker-compose -f docker/web/docker-compose.yml down

echo "=== All checks passed ==="
