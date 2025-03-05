FROM ubuntu:22.04

ENV TERM=xterm

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.4)" > /dev/null 2>&1

ENV PATH="/root/.config/herd-lite/bin:$PATH"
ENV PHP_INI_SCAN_DIR="/root/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

WORKDIR /opt

ENTRYPOINT [ "bash", "-c" ]
