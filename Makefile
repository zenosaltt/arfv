SOURCE := src/main.typ
BUILD_DATE := $(shell date +%d%m%y)
OUTPUT = build/ARFV-Notes_$${RELEASE_TAG:+$${RELEASE_TAG}_}$(BUILD_DATE).pdf
TYPST_SOURCES := $(shell find src -type f -name '*.typ')
TOOLS_IMAGE := arfv-tools:0.15.1
TYPST_DIAGNOSTIC_FORMAT ?= human
DOCKER_OPTIONS = --user "$$(id -u):$$(id -g)" --env HOME=/tmp --env XDG_CACHE_HOME=/work/.cache --mount "type=bind,source=$(CURDIR),target=/work" --workdir /work
DOCKER_RUN = docker run --rm $(DOCKER_OPTIONS) $(TOOLS_IMAGE)
export RELEASE_TAG

.PHONY: docker-image build watch docker-build format format-check prose-check check clean

docker-image:
	@docker build --quiet --tag $(TOOLS_IMAGE) . >/dev/null

format: docker-image
	$(DOCKER_RUN) typstyle --line-width 80 --wrap-text=fill --inplace $(TYPST_SOURCES)
	$(DOCKER_RUN) python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

format-check: docker-image
	@$(DOCKER_RUN) typstyle --line-width 80 --wrap-text=fill --check $(TYPST_SOURCES)
	@$(DOCKER_RUN) python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

prose-check: docker-image
	@$(DOCKER_RUN) sh -c 'test -d .github/vale/Harper || vale sync'
	@$(DOCKER_RUN) vale README.md $(TYPST_SOURCES)

check:
	@log=$$(mktemp) || exit 1; trap 'rm -f "$$log"' 0; \
	green=; red=; reset=; \
	if [ -t 1 ] && [ -z "$${NO_COLOR+x}" ] && [ "$${TERM:-dumb}" != dumb ]; then \
		green=$$(printf '\033[32m'); red=$$(printf '\033[31m'); \
		reset=$$(printf '\033[0m'); \
	fi; \
	failed=0; \
	for target in format-check prose-check build; do \
		if $(MAKE) --no-print-directory "$$target" >"$$log" 2>&1; then \
			printf '%s✓ PASS%s %s\n' "$$green" "$$reset" "$$target"; \
		else \
			printf '%s✗ FAIL%s %s\n' "$$red" "$$reset" "$$target"; \
			sed 's/^/  /' "$$log"; \
			failed=1; \
		fi; \
	done; \
	exit "$$failed"

build: docker-image
	@mkdir -p build
	@$(DOCKER_RUN) typst compile --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) "$(OUTPUT)"

watch: docker-image
	mkdir -p build
	$(DOCKER_RUN) typst watch --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) "$(OUTPUT)"

docker-build: build

clean:
	rm -f build/ARFV-Notes_*.pdf build/document.pdf
