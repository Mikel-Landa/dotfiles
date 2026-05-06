.PHONY: test test-diff

test:
	@nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"

test-diff:
	@nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/diff/ { minimal_init = 'tests/minimal_init.lua' }"
