# zmd73_microservices
zmd73 microservices repository

# Выполнено ДЗ gitlab-ci-1. Устройство Gitlab CI. Построение процесса непрерывной поставки

1.Создана ветка gitlab-ci-1

2.Создаем новую ВМ
```
yc compute instance create \
--name gitlab-ci \
--zone ru-central1-a \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=50 \
--ssh-key ~/.ssh/id_rsa.pub
```
3.Устанавливаем Docker

4.Создаем необходимые директории м docker-compose файл
```
mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
cd /srv/gitlab
touch docker-compose.yml
```
```
web:
  image: 'gitlab/gitlab-ce:latest'
  restart: always
  hostname: 'gitlab.example.com'
  environment:
    GITLAB_OMNIBUS_CONFIG: |
      external_url 'http://<YOUR-VM-IP>'
  ports:
    - '80:80'
    - '443:443'
    - '2222:22'
  volumes:
    - '/srv/gitlab/config:/etc/gitlab'
    - '/srv/gitlab/logs:/var/log/gitlab'
    - '/srv/gitlab/data:/var/opt/gitlab'
```
https://docs.gitlab.com/ee/install/docker.html

5.В той же директории, где docker-compose.yml ( /srv/gitlab ) запускаем docker compose up -d

6.Заходим, проверяем

7.cd /etc/gitlab
gitlab-rake "gitlab:password:reset[root]"

8.Создаем группу и тестовый проект

9.Добавляем ещё один remote к своему локальному infra-репозиторию
```
git checkout -b gitlab-ci-1
git remote add gitlab ssh://git@<your-vm-ip>:2222/homework/example.git
git push gitlab gitlab-ci-1
```
10.Создаем в корне репозитория .gitlab-ci.yml следующего содержания
```
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  script:
    - echo 'Building'

test_unit_job:
  stage: test
  script:
    - echo 'Testing 1'

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

deploy_job:
  stage: deploy
  script:
    - echo 'Deploy'
```
11.Пушим и проверяем статус pipeline

12.Получаем token Settings -> CI/CD -> Pipelines -> Runners

13. На сервере, где работает Gitlab CI, выполняем команду:
```
docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
```

14.Регистрируем runner.
```
docker exec -it gitlab-runner gitlab-runner register \
--url http://<your-ip>/ \
--non-interactive \
--locked=false \
--name DockerRunner \
--executor docker \
--docker-image alpine:latest \
--registration-token <your-token> \
--tag-list "linux,xenial,ubuntu,docker" \
--run-untagged
```

15.Push с тэгами
```
git commit -am '#4 add logout button to profile page'
git tag 2.4.10
git push gitlab gitlab-ci-1 --tags
```


### Лекция 22
#### 22.1 Мониторинг с Prometheus
Созданы Dockerfile и конфигурация Prometheus.
Команда для сборки всех образов приложений:
```
export USER_NAME=username
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
```
Отредактирован файл docker-compose.yml для запуска контейненеров с Prometheus. Убраны команды build, Добавлены network aliases.
Контейнеры загружены в [DockerHub](https://hub.docker.com/u/ayden1st).
#### 22.2 Задания со *
Добален мониторинг БД с помощью percona/mongodb_exporter.
Добален мониторинг Blackbox.
Создан Makefile для сборки и отправки образов.
