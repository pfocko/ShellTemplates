TEST_IMAGE ?= alpine:3.9

all:

rights:
	chmod +x shellTemplates.sh test.sh tests/env.sh

clean:
	find tests -type f -name *.test -exec rm {} \;
	find tests -type f -name *.tmp  -exec rm {} \;

test: clean rights
	./test.sh

dockertest: clean rights
	docker run --name test_ShellTemplates -v $(PWD):/ShellTemplates -w /ShellTemplates $(TEST_IMAGE) ./test.sh
	docker rm test_ShellTemplates