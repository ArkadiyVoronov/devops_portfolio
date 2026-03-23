#!/bin/bash
# scripts/diagnose.sh

echo "=== Repository Structure Diagnosis ==="

# Текущая директория
echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

# Поиск всех Dockerfiles
echo "=== Searching for Dockerfiles ==="
find . -name "Dockerfile*" -type f

# Поиск директорий
echo "=== Checking directories ==="
for dir in . .. /github /github/workspace /github/home /usr/src /var/lib /tmp; do
    if [ -d "$dir" ]; then
        echo "Directory: $dir/"
        ls -la $dir/ 2>/dev/null | head -20
    fi
done

# Проверка переменных окружения
echo "=== Environment Variables ==="
printenv | grep -E "(GITHUB|HOME|PATH|PWD|WORKSPACE)"
