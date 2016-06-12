#===============================
#
# Docker Environments makefile
#
#===============================
SHELL:=/bin/sh
NS = your docker namespace
VERSION ?= latest

.PHONY: build clean-stopped-containers clean-dangling-images build-base-node build-angular build-android build-jenkins build-redis build-redis-alpine build-grid run-jenkins
clean-stopped-containers:
	@echo 'Cleaning stopped containers'
	@docker rm $$(command docker ps -q -f status=exited)
clean-dangling-images:
	@echo "Cleaning dangling"
	@docker rmi $$(command docker images -q --filter='dangling=true')
build: build-base-node build-angular build-android build-jenkins build-redis build-redis-alpine build-grid build-nginx
build-base-node:
	@echo 'Building base node'
	@docker build -t base_node base_node_container/.
build-jenkins:
	@echo 'Building jenkins'
	@docker build -t jenkins jenkins_container/.
build-angular:
	@echo 'Building angular'
	@docker build -t angular angular_container/.
build-android:
	@echo 'Building android'
	@docker build -t android android_container/.
build-grid:
	@echo 'Building grid'
	@docker build -t grid selenium_container/.
build-redis:
	@echo 'Building redis'
	@docker build -t redis redis_container/.
build-redis-alpine:
	@echo 'Building redis-alpine'
	@docker build -t redis_alpine redis_alpine_container/.
build-nginx:
	@echo 'Building nginx'
	@docker build -t nginx nginx_container/.
