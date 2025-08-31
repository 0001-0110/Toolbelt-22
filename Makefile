.PHONY: test coverage archive clean

test:
	lua tests/test_runner.lua

coverage: clean
	lua -lluacov tests/test_runner.lua
	luacov

archive: clean
	MOD_NAME=$$(jq -r '.name' info.json) && \
	VERSION=$$(jq -r '.version' info.json) && \
	ZIP_NAME="$${MOD_NAME}_$${VERSION}.zip" && \
	echo $$MOD_NAME && \
	git archive --format=zip --prefix="$$MOD_NAME/" --output="$$ZIP_NAME" HEAD

clean:
	rm -rf *.out *.zip
