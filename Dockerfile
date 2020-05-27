FROM buildpack-deps:buster
ARG rust_version

RUN set -ex; \
    apt-get -y update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    musl-tools \
    sudo \
    build-essential \
    file \
    ruby-full \
    locales \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    useradd -m -s /bin/bash linuxbrew; \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers; \
    localedef -i en_US -f UTF-8 en_US.UTF-8

USER linuxbrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew \
    HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar \
    HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew \
    PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH} \
    MANPATH=/home/linuxbrew/.linuxbrew/share/man:${MANPATH} \
    INFOPATH=/home/linuxbrew/.linuxbrew/share/info:${INFOPATH}
RUN set -ex; \
    brew install gcc; \
    brew tap aws/tap; \
    brew install aws-sam-cli

ENV LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib" \
    CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/isl@0.18/include" \
    PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib/pkgconfig"

WORKDIR /home/linuxbrew
ENV PATH=/home/linuxbrew/.cargo/bin:${PATH} \
    RUST_VERSION=${rust_version}
RUN set -eux; \
    rustArch='x86_64-unknown-linux-gnu'; \
    url="https://static.rust-lang.org/rustup/archive/1.21.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain ${rust_version}; \
    rm rustup-init; \
    rustup target add x86_64-unknown-linux-musl; \
    rustup --version; \
    cargo --version; \
    rustc --version;

VOLUME [ "/opt/build" ]
WORKDIR /opt/build