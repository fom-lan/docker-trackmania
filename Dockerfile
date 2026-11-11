# build trackmania_exporter
FROM python:3.14.10-alpine3.24 AS exporter-build
WORKDIR /build

RUN apk upgrade && apk add binutils upx && pip3 install --no-cache-dir uv

COPY trackmania_exporter/uv.lock .
COPY trackmania_exporter/pyproject.toml .

RUN uv sync --group build

COPY trackmania_exporter/*.py .

RUN uv run pyinstaller --onefile --console --clean --strip trackmania_exporter.py

# prepare server files
FROM alpine:3.24.4 AS server-files

RUN apk update && apk add unzip gcompat

WORKDIR /server

ADD https://nadeo-download.cdn.ubi.com/trackmania/TrackmaniaServer_Latest.zip server.zip

RUN unzip server.zip

# build main image
FROM alpine:3.24.4

ARG TMSERVER_VERSION="Latest" \
    VERSION \
    BUILD_DATE \
    REVISION

LABEL org.opencontainers.image.title="Trackmania Server" \
      org.opencontainers.image.description="Server for the game Trackmania, released in 2020 by Nadeo." \
      org.opencontainers.image.authors="Nicolas Graf <nicolas.j.graf@gmail.com>" \
      org.opencontainers.image.vendor="Evo" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.revision=${REVISION}

RUN apk update && apk add gcompat xmlstarlet

USER 1000

WORKDIR /server

COPY --from=server-files --chown=1000:1000 /server/TrackmaniaServer .
COPY --from=server-files --chown=1000:1000 /server/Packs Packs
COPY --from=server-files --chown=1000:1000 /server/UserData UserData

COPY --chmod=0755 --chown=1000:1000 entrypoint.sh .
COPY --chmod=0755 --chown=1000:1000 --from=exporter-build /build/dist/trackmania_exporter .

HEALTHCHECK --interval=5s --timeout=5s --start-period=20s --retries=3 \
    CMD nc -z -v 127.0.0.1 5000 || exit 1

CMD [ "./entrypoint.sh" ]
