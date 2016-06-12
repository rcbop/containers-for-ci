.PHONY: run-jenkins stop-jenkins compose-jenkins-up

run-jenkins:
	# CHANGE DOCKER HOME LOCATION
	@docker run --name=jenkins-master -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /jenkins/data:/var/jenkins_home --restart=unless-stopped -p 8080:8080 -p 50000:50000 -u `id -u jenkins`:`id -g jenkins` -d jenkins
stop-jenkins:
	@docker stop jenkins-master
compose-jenkins-up:
	@docker-compose up -d .
compose-jenkins-build:
	@docker-compose build .
