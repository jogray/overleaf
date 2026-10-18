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

show: 
	@echo "MONOREPO_ROOT: $(MONOREPO_ROOT)"
	@echo "MONOREPO_REVISION: $(MONOREPO_REVISION)"
	@echo "BRANCH_NAME: $(BRANCH_NAME)"
	@echo "BRANCH_NAME_TAG_SAFE: $(BRANCH_NAME_TAG_SAFE)"
	@echo "OVERLEAF_BASE_BRANCH: $(OVERLEAF_BASE_BRANCH)"
	@echo "OVERLEAF_BASE_TAG: $(OVERLEAF_BASE_TAG)"
	@echo "OVERLEAF_BRANCH: $(OVERLEAF_BRANCH)"
	@echo "OVERLEAF_TAG: $(OVERLEAF_TAG)"

build-base:
	cp server-ce/.dockerignore $(MONOREPO_ROOT)
	docker build \
	  --build-arg BUILDKIT_INLINE_CACHE=1 \
	  --progress=plain \
	  --file server-ce/Dockerfile.base \
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
	  --file server-ce/Dockerfile \
	  --tag $(OVERLEAF_TAG) \
	  --tag $(OVERLEAF_BRANCH) \
	  $(MONOREPO_ROOT)
	rm $(MONOREPO_ROOT)/.dockerignore

.PHONY: all \
	build-base build-community