# tests/integration/test_local_deployment.py
import os
import subprocess
import time
import requests

def test_local_deployment():
    """Тестирование локального развертывания"""
    # Сборка Docker образов
    subprocess.run(['docker', 'build', '-f', 'docker/web/Dockerfile', '.'], cwd='docker/web')
    subprocess.run(['docker', 'build', '-f', 'docker/database/Dockerfile', '.'], cwd='docker/database')

    # Запуск Docker Compose
    subprocess.run(['docker-compose', 'up', '-d'], cwd='docker/web')
    subprocess.run(['docker-compose', 'up', '-d'], cwd='docker/database')

    # Ожидание запуска сервисов
    time.sleep(15)

    # Тестирование веб-сервера
    response = requests.get('http://localhost:8080')
    assert response.status_code == 200
    assert 'DevOps Application' in response.text

    # Тестирование базы данных
    db_result = subprocess.run(
        ['docker', 'exec', 'database_container', 'psql', '-U', 'devops', '-d', 'devops_db', '-c', '\l'],
        capture_output=True,
        text=True
    )
    assert db_result.returncode == 0
    assert 'devops_db' in db_result.stdout

    # Остановка сервисов
    subprocess.run(['docker-compose', 'down'], cwd='docker/web')
    subprocess.run(['docker-compose', 'down'], cwd='docker/database')
  
