PACKAGER_URL := https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh

.PHONY: check dist

all: check

check:
	@luacheck -q $(shell git ls-files '*.lua')

dist:
	@curl -s $(PACKAGER_URL) | bash -s -- -dn 'AddonLocale-{project-version}{nolib}{classic}'
