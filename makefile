MONOREPO_ROOT := ./
HERE=$(shell pwd)
export MONOREPO_REVISION := $(shell git rev-parse HEAD)
export BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
export BRANCH_NAME_TAG_SAFE ?= $(subst /,--,$(BRANCH_NAME))
export OVERLEAF_BASE_BRANCH ?= jogit/sharelatex-base:$(BRANCH_NAME_TAG_SAFE)
export OVERLEAF_BASE_TAG ?= jogit/sharelatex-base:$(BRANCH_NAME_TAG_SAFE)-$(MONOREPO_REVISION)
export OVERLEAF_BRANCH ?= jogit/sharelatex:$(BRANCH_NAME_TAG_SAFE)
export OVERLEAF_TAG ?= jogit/sharelatex:$(BRANCH_NAME_TAG_SAFE)-$(MONOREPO_REVISION)

all: build-base build-community

build-base:
	cp server-ce/.dockerignore $(MONOREPO_ROOT)
	docker build \
	  --build-arg BUILDKIT_INLINE_CACHE=1 \
	  --progress=plain \
	  --file Dockerfile-base \
	  --tag $(OVERLEAF_BASE_TAG) \
	  --tag $(OVERLEAF_BASE_BRANCH) \
	  $(MONOREPO_ROOT)
	rm $(MONOREPO_ROOT)/.dockerignore


build-community: 
	cp server-ce/.dockerignore $(MONOREPO_ROOT)
	docker build \
	  --build-arg BUILDKIT_INLINE_CACHE=1 \
	  --progress=plain \
	  --build-arg OVERLEAF_BASE_TAG \
	  --label "com.overleaf.ce.revision=$(MONOREPO_REVISION)" \
	  --file Dockerfile \
	  --tag $(OVERLEAF_TAG) \
	  --tag $(OVERLEAF_BRANCH) \
	  $(MONOREPO_ROOT)
	rm $(MONOREPO_ROOT)/.dockerignore

.PHONY: all \
	build-base build-community