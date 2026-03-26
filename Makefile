MOUNTPATH := /asciidoxy
VERSION := 0.3

--check-%:
	@if [ "`command -v ${*}`" = "" ]; then \
		echo "Command ${*} not found in path";  \
		exit 1; \
	fi

--guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set: $*=abc123 make $(MAKECMDGOALS)"; \
		exit 1; \
	fi

filter:
	sed -n -f doxygen/filter/doxygen-bash.sed doxygen/filter/doxygen-bash.sed src/build.sh | grep .

doxygen: --check-podman
	podman run --rm -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && doxygen"

doxygen-generate: --check-podman
	podman run --rm -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && doxygen -g Doxyfile"

asciidoxy: --check-podman
	podman run --rm -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && asciidoxy \
		--require asciidoctor-diagram \
		--spec-file packages.toml \
		--base-dir text \
		--destination-dir src/site/asciidoc \
		--build-dir build \
		--template-dir templates \
		-b adoc \
		text/index.adoc"

asciidoc: --check-podman
	podman run --rm --dns 8.8.8.8 -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && mvn -f pom.xml generate-resources"

asciidoc-local: --check-mvn
	mvn -f pom.xml generate-resources

publish: --check-podman --guard-CONFLUENCE_URL --guard-CONFLUENCE_SPACE_KEY --guard-CONFLUENCE_ANCESTOR_ID --guard-CONFLUENCE_USER --guard-CONFLUENCE_TOKEN
	podman run --rm --dns 8.8.8.8 -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
        -e CONFLUENCE_URL \
        -e CONFLUENCE_SPACE_KEY \
        -e CONFLUENCE_ANCESTOR_ID \
        -e CONFLUENCE_USER \
        -e CONFLUENCE_TOKEN \
		sh -c "cd $(MOUNTPATH) && mvn -f pom.xml -P generate-docs-and-publish generate-resources"

versions:
	podman run --rm -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && doxygen --version"
	podman run --rm -v $(CURDIR):$(MOUNTPATH) \
		-it docker.io/unexist/asciidoxy-builder:$(VERSION) \
		sh -c "cd $(MOUNTPATH) && asciidoxy -h | grep -E '[0-9\.]{5}'"

clean:
	rm -rf build/*
	rm -rf doxygen/xml/*
	rm -rf doxygen/html/*
	rm -rf src/site/asciidoc/*

docs: doxygen asciidoxy asciidoc

open-doxygen: --check-open
	open doxygen/html/index.html

open-asciidoc: --check-open
	open target/static/documentation/index.html

