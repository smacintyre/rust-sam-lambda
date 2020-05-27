rust_version = "1.43.1"

.PHONEY : docker-run docker-build

include gmsl
function = $(call lc,$(@:build-%Function=%))

ifeq ($(shell uname), Linux)
	linker = CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=musl-gcc
endif

build-% :
	$(linker) cargo build --package $(function) --target x86_64-unknown-linux-musl
	cp ./target/x86_64-unknown-linux-musl/debug/$(function) $(ARTIFACTS_DIR)/bootstrap

# From https://stackoverflow.com/a/58795217
docker_credentials = docker-credential-$$(jq -r .credsStore ~/.docker/config.json)
dockerhub_user = $$($(docker_credentials) list | \
	jq -r '. | to_entries[] | select(.key | contains("docker.io")) | last(.value)')

docker-image : Dockerfile
	@touch $@
	docker build \
		--tag $(dockerhub_user)/rust-sam:latest \
		--tag $(dockerhub_user)/rust-sam:$(rust_version) \
		--build-arg rust_version=$(rust_version) \
		.

docker-run : docker-image
	@docker run -it --rm --volume $$(pwd):/opt/build $(dockerhub_user)/rust-sam:latest bash -l

docker-build : docker-image
	@docker run --tty --rm $(dockerhub_user)/rust-sam:latest sam build