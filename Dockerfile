FROM rust:1.90-bookworm AS parser

RUN cargo install typst2vast --version 0.1.0 --locked

FROM ghcr.io/typst/typst:0.15.1 AS typst

FROM python:3.13-slim-bookworm

ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) typstyle_arch=x86_64; vale_arch=64-bit ;; \
         arm64) typstyle_arch=aarch64; vale_arch=arm64 ;; \
         *) echo "Unsupported Docker architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl --fail --location --silent --show-error \
         "https://github.com/typstyle-rs/typstyle/releases/download/v0.15.1/typstyle-${typstyle_arch}-unknown-linux-gnu" \
         --output /usr/local/bin/typstyle \
    && chmod +x /usr/local/bin/typstyle \
    && curl --fail --location --silent --show-error \
         "https://github.com/vale-cli/vale/releases/download/v3.23.0/vale_3.23.0_Linux_${vale_arch}.tar.gz" \
         | tar -xz -C /usr/local/bin vale

COPY --from=typst /bin/typst /usr/local/bin/typst
COPY --from=parser /usr/local/cargo/bin/typst2vast /usr/local/bin/typst2vast

WORKDIR /work
