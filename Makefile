SOURCE := main.typ
OUTPUT := build/document.pdf
TYPSTYLE ?= typstyle
TYPST_SOURCES := $(shell find . -type f -name '*.typ' -not -path './.git/*' -not -path './build/*')
TYPST_IMAGE := ghcr.io/typst/typst:0.15.1
FONT_PATH := fonts
TYPST_DIAGNOSTIC_FORMAT ?= human
DOCKER_OPTIONS = --user "$$(id -u):$$(id -g)" --env HOME=/tmp --mount "type=bind,source=$(CURDIR),target=/work" --workdir /work
DOCKER_RUN = docker run --rm $(DOCKER_OPTIONS) $(TYPST_IMAGE)
export RELEASE_TAG

.PHONY: build watch docker-build format format-check clean

format:
	$(TYPSTYLE) --line-width 80 --wrap-text=fill --inplace $(TYPST_SOURCES)
	python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

format-check:
	$(TYPSTYLE) --line-width 80 --wrap-text=fill --check $(TYPST_SOURCES)
	python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

build:
	mkdir -p build
	typst compile --font-path $(FONT_PATH) --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) $(OUTPUT)

watch:
	mkdir -p build
	typst watch --font-path $(FONT_PATH) --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) $(OUTPUT)

docker-build:
	mkdir -p build
	$(DOCKER_RUN) compile --font-path $(FONT_PATH) --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) $(OUTPUT)

clean:
	rm -f $(OUTPUT)
