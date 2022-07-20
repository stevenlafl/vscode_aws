
build:
	docker build -t stevenlafl/vscode_aws --build-arg DOCKER_GROUPID="$(shell awk -F\: '/docker/ {print $$3}' /etc/group)" -f ./Dockerfile .

run:
	docker run -it \
		-p 8080:8080 \
		-v $(shell pwd):/home/coder/project \
		-v /var/run/docker.sock:/var/run/docker.sock \
		stevenlafl/vscode_aws
