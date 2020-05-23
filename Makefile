include gmsl
function = $(call lc,$(@:build-%Function=%))

build-% :
	cargo build --package $(function) --target x86_64-unknown-linux-musl
	cp ./target/x86_64-unknown-linux-musl/debug/$(function) $(ARTIFACTS_DIR)/bootstrap

