BIN = ./node_modules/.bin/
SELENIUM_JAR = selenium-server-standalone-2.45.0.jar
SELENIUM_PATH = bin/$(SELENIUM_JAR)
SELENIUM_URL = http://selenium-release.storage.googleapis.com/2.45/$(SELENIUM_JAR)
SRC = $(wildcard src/*.js)
BABEL_CMD = --optional runtime src --out-dir out

.PHONY: base-install install lint server selenium-server grid test

base-install:
	@npm install

install: base-install
	@echo "Downloading selenium-server..."
	@rm $(SELENIUM_PATH)
	wget $(SELENIUM_URL) --quiet -O $(SELENIUM_PATH)
	@echo "Downloaded selenium-server."

build: base-install
	@babel $(BABEL_CMD) >> /dev/null

prepublish:
	@babel $(BABEL_CMD)

selenium-server:
	@java -jar $(SELENIUM_PATH)

server:
	@python -m SimpleHTTPServer 9876

grid: build
	@docker-compose --file config/docker-compose.yml up

lint:
	@$(BIN)eslint $(SRC) -c .eslintrc

test:
	@./bin/test --suite src/test/test-integrator-actions
