FROM debian:11-slim

LABEL org.opencontainers.image.title="TS3AudioBot" \
    org.opencontainers.image.description="Automated Docker builds of TS3AudioBot with support for arm64 and including more dependencies." \
    org.opencontainers.image.authors="watn3y <me@watn3y.de>" \
    org.opencontainers.image.vendor="watn3y.de" \
    org.opencontainers.image.documentation="https://git.watn3y.de/watn3y/TS3AudioBot-Docker/src/branch/master/README.md" \
    org.opencontainers.image.url="https://git.watn3y.de/watn3y/TS3AudioBot-Docker" \
    org.opencontainers.image.source="https://git.watn3y.de/watn3y/TS3AudioBot-Docker" \
    org.opencontainers.image.licenses="OSL-3.0" \
    org.opencontainers.image.base.name="docker.io/library/debian:11-slim" 


ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app


# TS3AudioBot 0.12.0 targets .NET Core 3.1, which needs OpenSSL 1.1 and an older ICU. Debian 11 still ships both.
# We download from snapshot.debian.org since archives for Debian 11 are purged from the live mirror.
RUN sed -i -n 's/^# \(deb http:\/\/snapshot\.debian\.org.*\)$/\1/p' /etc/apt/sources.list \
    && DEBIAN_FRONTEND=noninteractive  apt-get -o Acquire::Check-Valid-Until=false update \
    && DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
    libopus0 \
    libssl1.1 \
    libicu67 \
    ffmpeg \
    ca-certificates \
    wget \
    xz-utils \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    # TS3AudioBot loads the Opus library by the bare name "libopus". Debian ships it as libopus.so.0.
    && ln -sf "$(find / -name 'libopus.so.0' 2>/dev/null | head -n1)" \
    "$(dirname "$(find / -name 'libopus.so.0' 2>/dev/null | head -n1)")/libopus.so"


# yt-dlp-ejs and curl_cffi require Python >= 3.10, but Debian 11 only ships 3.9. We use uv to provide a self-contained Python 3.12 in a venv.
ENV UV_INSTALL_DIR=/usr/local/bin \
    UV_PYTHON_INSTALL_DIR=/opt/uv-python \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:${PATH}"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && uv python install 3.12 \
    && uv venv --python 3.12 "${VIRTUAL_ENV}" \
    && uv pip install --python "${VIRTUAL_ENV}/bin/python" --no-cache \
    yt-dlp \
    yt-dlp-ejs \
    curl_cffi \
    && ln -s "${VIRTUAL_ENV}/bin/python" /usr/local/bin/python3 \
    && ln -s "${VIRTUAL_ENV}/bin/yt-dlp" /usr/local/bin/youtube-dl \
    && chmod -R a+rX /opt/uv-python /opt/venv


RUN case "${TARGETARCH}" in \
    amd64) DENO_ARCH="x86_64-unknown-linux-gnu" ;; \
    arm64) DENO_ARCH="aarch64-unknown-linux-gnu" ;; \
    *) echo "Deno has no prebuilt binary for TARGETARCH=${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && wget -qO /tmp/deno.zip "https://github.com/denoland/deno/releases/latest/download/deno-${DENO_ARCH}.zip" \
    && unzip -o /tmp/deno.zip -d /usr/local/bin \
    && rm /tmp/deno.zip \
    && chmod +x /usr/local/bin/deno


RUN case "${TARGETARCH}" in \
    amd64) TS3AB_BRANCH="master_linux_x64" ;; \
    arm64) TS3AB_BRANCH="master_linux_arm64" ;; \
    *) echo "No TS3AudioBot nightly build for TARGETARCH=${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && wget -qO- "https://splamy.de/api/nightly/projects/ts3ab/${TS3AB_BRANCH}/download" \
    | tar xz -C /app \
    && chmod +x /app/TS3AudioBot

WORKDIR /app/data
RUN useradd --no-create-home --uid 9999 teamspeak3 \
    && chown -R teamspeak3 /app/data

USER teamspeak3

ENTRYPOINT [ "/app/TS3AudioBot" ]
CMD ["--non-interactive", "--stats-disabled"]
