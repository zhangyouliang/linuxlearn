.PHONY: all test

# https://github.com/containous/traefik/blob/master/Makefile
# https://www.kancloud.cn/kancloud/make-command/45594

SRCS = $(shell git ls-files '*.go' | grep -v '^vendor/')
DOCKER_VERSION=18.06.1

DOCKER_BUILD_ARGS := $(if $(DOCKER_VERSION), "--build-arg=DOCKER_VERSION=$(DOCKER_VERSION)",)

print-%: ; @echo $*=$($*)

default: binary

binary:
	docker -v

clear-static:
	rm -rf $(CURDIR)/site

all:
#	@echo "all"
	@echo $(DOCKER_BUILD_ARGS)

fmt:
	gofmt -s -l -w $(SRCS)

#test: build  ## run the unit and integration tests
#	$(DOCKER_RUN_TRAEFIK) ./script/make.sh generate test-unit binary test-integration

#build: dist
#	docker build $(DOCKER_BUILD_ARGS) -t "$(TRAEFIK_DEV_IMAGE)" -f build.Dockerfile .

dist:
	mkdir dist

run-dev:
	@echo "run-dev"

glide-install:
	 glide install

#text= Hello World
# phony
#test:
#	@# 测试
#	@echo TODO
#	@# 输出变量
#	@echo $(text)
#	@# 输出环境变量
#	@echo $$HOME
#	@# make 内置变量
#	@# $(CC) -o output input.c
#	@echo $(CC)

# 自动变量  $@, $<
# $@指代当前目标
# a.txt b.txt c.txt:
#	touch $@
# $< 指代第一个前置条件,比如,规则为 t: p1 p2，那么$< 就指代p1。
# a.txt: b.txt c.txt
#	cp $< $@


####
#dest/%.txt: src/%.txt
#	@[ -d dest] || mkdir dest
#	cp $< $@

#### shell 命令
## '*.go'  *.go 是有区别的
#srcfiles = $(shell git ls-files '*.go' | grep -v '^vendor/')
#srcfiles = $(shell git ls-files '*.go')
#test:
#	@echo $(srcfiles)


######## 判断和循环
ifeq ($(CC),gcc)
	libs=$(libs_for_gcc)
else
	libs=$(normal_libs)
endif
### for 循环测试
LIST = one two three
test:
	@# 双 $
	for i in $(LIST); do \
		echo $$i; \
	done
# 等同于
#all:
#    for i in one two three; do \
#        echo $i; \
#    done