# Getting started with Rust and AWS SAM <!-- omit in toc -->

- [Goals](#goals)
- [Assumptions](#assumptions)
- [Installing Prerequisits](#installing-prerequisits)
  - [Install Rust](#install-rust)
  - [Install musl libc tools](#install-musl-libc-tools)
    - [macOS](#macos)
    - [Linux](#linux)
  - [Install AWS SAM CLI](#install-aws-sam-cli)
    - [Install the CLI](#install-the-cli)
    - [Verify the installation](#verify-the-installation)
  - [Docker (Optional)](#docker-optional)
- [A note about linking on macOS](#a-note-about-linking-on-macos)
- [A note on debug and release builds](#a-note-on-debug-and-release-builds)
- [A note about the GNU Make Standard Library](#a-note-about-the-gnu-make-standard-library)
- [Running](#running)
  - [Building](#building)
  - [Deploying](#deploying)
- [Inspirations and Sources](#inspirations-and-sources)

## Goals

## Assumptions

## Installing Prerequisits

### Install Rust

Install `rustup`, the Rust installer and version manager. Run the following command and follow the instructions on screen. You should be able to just accept the defaults.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

To verify the installation was successful run:

```bash
cargo --version
```

And you should see outpup like:

```text
cargo 1.43.0 (2cbe9048e 2020-05-03)
```

### Install musl libc tools

[AWS Lambda](https://aws.amazon.com/lambda/) will run our function in an [Amazon Linux Environment](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html).
So we will use [musl libc](https://musl.libc.org/) "libc" implementaiton so we can staticly link our binaries for running on Lambda.
We will use this to eliminates the need an EC2 instance with Amazon Linux to compile our lambda functions.

#### macOS

The musl libc tools are installed via [Homebrew](https://brew.sh/).
Please make sure you have it installed before proceeding.

Install the target for musl:

```bash
rustup target add x86_64-unknown-linux-musl
```

Install musl-tools:

```bash
brew install filosottile/musl-cross/musl-cross
```

#### Linux

Install the target for musl:

```bash
rustup target add x86_64-unknown-linux-musl
```

Install musl-tools:

```bash
sudo apt install musl-tools
```

### Install AWS SAM CLI

We require SAM CLI v0.50+.
The SAM CLI is installed via [Homebrew](https://brew.sh/) on both macOS and Linux.
Please make sure those are installed and follow these instructions.
For full installation details, please see the [offical docs](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html).

#### Install the CLI

```bash
brew tap aws/tap
brew install aws-sam-cli
```

#### Verify the installation

```bash
sam --version
```

We require version **0.50.0** or greater:

```text
SAM CLI, version 0.51.0
```

### Docker (Optional)

Docker is required for local invocation. However, only a small portion of AWS' infastructure can be simulated locally via Docker. So this can be of limited use.

- [macOS installation instructions](https://docs.docker.com/docker-for-mac/install/)
- [Linux installation instructions](https://docs.docker.com/engine/install/)

## A note about linking on macOS

Under macOS we need to tell `cargo` about our musl based linker.
So we have added a config file in the `.cargo` directory: `.cargo/config`

```toml
[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"
```

## A note on debug and release builds

Currently this project is set to only do debug builds.
In the future, I plan the ability to switch between build and debug.
And, hopefully, add local debugging.

## A note about the GNU Make Standard Library

The files `gsml` and `__gsml` are the [GNU Make Standard Library](https://gmsl.sourceforge.io/) or GMSL.
They provide useful functions but so far we are only using `lc` to lowercase strings.
This might be overkill when we could be using the stardard shell command `tr`.
But I expect as more functionality is added to this project more will be used.
The GMSL is released under the BSD License.

## Running

### Building

### Deploying

## Inspirations and Sources

- [AWS Lambda Functions written in Rust](https://robertohuertas.com/2018/12/02/aws-lambda-rust/) by Roberto Huertas
