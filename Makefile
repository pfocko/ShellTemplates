TEST_IMAGE ?= alpine:3.9

all:

rights:
	chmod +x shellTemplates.sh test.sh tests/env.sh

test: rights
	./test.sh

dockertest: rights
	docker run --name test_ShellTemplates -v $(PWD):/ShellTemplates -w /ShellTemplates $(TEST_IMAGE) ./test.sh
	docker rm test_ShellTemplates