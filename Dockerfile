FROM python:3.13-slim-trixie

ARG GRAPHIFY_VERSION

RUN apt-get update \
 && apt-get install -y --no-install-recommends git tini \
 && rm -rf /var/lib/apt/lists/* \
 && pip install --no-cache-dir "graphifyy${GRAPHIFY_VERSION:+==$GRAPHIFY_VERSION}"

COPY rootfs/ /
RUN chmod 755 /usr/local/bin/entrypoint.sh /usr/local/bin/graphify-build \
 && useradd --create-home --uid 1000 graphify \
 && mkdir /work && chown graphify /work

ARG IMAGE_VERSION=dev
ENV IMAGE_VERSION=$IMAGE_VERSION \
    GRAPHIFY_BACKEND=none

USER graphify
WORKDIR /work
VOLUME ["/work"]
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["graphify-build"]
