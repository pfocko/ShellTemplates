

all:

rights:
	chmod +x shellTemplates.sh test.sh tests/env.sh

test: rights
	./test.sh