namespace := pdouble16
imagebase := seleniumvideo-
version := 3.8.1

.PHONY: node-chrome node-firefox

all: node-chrome node-firefox

node-chrome:
	docker build --build-arg "SE_IMAGE=node-chrome" --build-arg "SE_VER=$(version)" --build-arg "BROWSER_COMMAND=/usr/bin/google-chrome" -t $(namespace)/$(imagebase)node-chrome:$(version) -f node/Dockerfile .

node-firefox:
	docker build --build-arg "SE_IMAGE=node-firefox" --build-arg "SE_VER=$(version)" --build-arg "BROWSER_COMMAND=/usr/bin/firefox" -t $(namespace)/$(imagebase)node-firefox:$(version) -f node/Dockerfile .
