# JS_PNPM_INSTALL_ARGS is a set of arguments passed to "pnpm install"
JS_PNPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
JS_PNPM_INSTALL_ARGS += --reporter append-only
endif

################################################################################

# js_exec returns a command that executes the supplied executable.
define js_exec
pnpm exec -- $1
endef

################################################################################

artifacts/link-dependencies.touch: package.json
	@mkdir -p "$(@D)"

ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS)
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

################################################################################

artifacts/linker/production/node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@"
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@" --frozen-lockfile
endif

	@touch "$@"
