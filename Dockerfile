FROM debian:11-slim

WORKDIR /processing

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    wget \
    xvfb \
    xauth \
    ca-certificates \
    libxrender1 \
    libxtst6 \
    tini \
  && wget --quiet https://github.com/processing/processing4/releases/download/processing-1290-4.1.2/processing-4.1.2-linux-x64.tgz \
  && tar xfz processing-4.1.2-linux-x64.tgz \
  && rm processing-4.1.2-linux-x64.tgz

ENTRYPOINT ["/usr/bin/tini", "--", "xvfb-run", "/processing/processing-4.1.2/processing-java"]
