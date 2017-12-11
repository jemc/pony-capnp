all: test
.PHONY: all test clean lldb lldb-test ci ci-setup test-regen

PKG=capnp
APP=capnpc-pony

bin/${APP}: $(shell find ${PKG} ${PKG}/${APP} .deps -name *.pony)
	mkdir -p bin
	ponyc --debug -o bin ${PKG}/${APP}

# bin/test: $(shell find ${PKG} .deps -name *.pony)
# 	mkdir -p bin
# 	ponyc --debug -o bin ${PKG}/test

# test: bin/test
# 	$^

test: test-regen

SCHEMA=${PKG}/${APP}/schema/schema.capnp

regen: bin/${APP} ${SCHEMA}
	env PATH=${PWD}/bin:${PATH} capnp compile -o pony ${SCHEMA}

test-regen:
	cp ${SCHEMA}.pony ${SCHEMA}.pony.old
	env PATH=${PWD}/bin:${PATH} capnp compile -o pony ${SCHEMA}
	mv ${SCHEMA}.pony ${SCHEMA}.pony.new
	mv ${SCHEMA}.pony.old ${SCHEMA}.pony
	colordiff -u ${SCHEMA}.pony ${SCHEMA}.pony.new

clean:
	rm -rf bin

lldb:
	lldb -o run -- $(shell which ponyc) --debug -o /tmp ${PKG}/test

# lldb-test: bin/test
# 	lldb -o run -- bin/test

ci: test

ci-setup:
