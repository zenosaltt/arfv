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
	@if [ "$(CHECK_PROGRESS)" = 1 ]; then docker build --quiet --tag $(TOOLS_IMAGE) . >/dev/null; \
	else PROGRESS_HIDE_SUCCESS=1 sh .github/scripts/progress.sh 'Preparing Docker tools image' docker build --quiet --tag $(TOOLS_IMAGE) .; fi

format: docker-image
	@sh .github/scripts/progress.sh 'Formatting Typst sources' $(DOCKER_RUN) typstyle --line-width 80 --wrap-text=fill --inplace $(TYPST_SOURCES)
	@sh .github/scripts/progress.sh 'Checking line width' $(DOCKER_RUN) python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

format-check: docker-image
	@sh .github/scripts/progress.sh 'Checking Typst formatting' $(DOCKER_RUN) typstyle --line-width 80 --wrap-text=fill --check $(TYPST_SOURCES)
	@sh .github/scripts/progress.sh 'Checking line width' $(DOCKER_RUN) python3 .github/scripts/check-line-width.py $(TYPST_SOURCES)

prose-check: docker-image
	@sh .github/scripts/progress.sh 'Preparing Vale styles' $(DOCKER_RUN) sh -c 'test -d .github/vale/Harper || vale sync'
	@sh .github/scripts/progress.sh 'Checking prose' $(DOCKER_RUN) vale README.md CONTRIBUTING.md $(TYPST_SOURCES)

check:
	@log=$$(mktemp) || exit 1; trap 'rm -f "$$log"' 0; \
	green=; red=; reset=; \
	if [ -t 1 ] && [ -z "$${NO_COLOR+x}" ] && [ "$${TERM:-dumb}" != dumb ]; then \
		green=$$(printf '\033[32m'); red=$$(printf '\033[31m'); \
		reset=$$(printf '\033[0m'); \
	fi; \
	failed=0; \
	if PROGRESS_LOG="$$log" PROGRESS_CLEAR=1 sh .github/scripts/progress.sh 'Preparing Docker tools image' $(MAKE) --no-print-directory CHECK_PROGRESS=1 docker-image; then \
		printf '%s✓ PASS%s docker-image\n' "$$green" "$$reset"; \
	else \
		printf '%s✗ FAIL%s docker-image\n' "$$red" "$$reset"; \
		sed 's/^/  /' "$$log"; \
		exit 1; \
	fi; \
	for target in format-check prose-check build; do \
		if PROGRESS_LOG="$$log" PROGRESS_CLEAR=1 sh .github/scripts/progress.sh "Running $$target" $(MAKE) --no-print-directory --assume-old=docker-image "$$target"; then \
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
	@sh .github/scripts/progress.sh 'Compiling PDF' $(DOCKER_RUN) typst compile --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) "$(OUTPUT)"

watch: docker-image
	@mkdir -p build
	@printf 'Watching Typst sources\n'
	@$(DOCKER_RUN) typst watch --diagnostic-format $(TYPST_DIAGNOSTIC_FORMAT) --input "release-tag=$${RELEASE_TAG}" $(SOURCE) "$(OUTPUT)"

docker-build: build

clean:
	rm -f build/ARFV-Notes_*.pdf build/document.pdf
