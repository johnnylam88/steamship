# steamship/lib/modules.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" modules "*) return ;; esac

# Dependencies
steamship_load_library config
steamship_load_library shell_features

# Track the order in which modules are sourced.
# shellcheck disable=SC2034
STEAMSHIP_MODULES_SOURCED=

steamship_load_module() {
	[ -n "${STEAMSHIP_ROOT}" ] || return

	if [ -f "${STEAMSHIP_ROOT}/modules/${1}.sh" ]; then
		# shellcheck disable=1090
		. "${STEAMSHIP_ROOT}/modules/${1}.sh"
	else
		echo 1>&2 "steamship: \`${1}' module not found."
		return 1
	fi
}

STEAMSHIP_LIBS_INIT="${STEAMSHIP_LIBS_INIT} steamship_modules_init"

steamship_modules_init() {
	[ -n "${STEAMSHIP_ROOT}" ] || return

	# Load all modules in the `modules` directory.
	STEAMSHIP_MODULES_SOURCED=
	for ssm_module_file in "${STEAMSHIP_ROOT}"/modules/*.sh; do
		# shellcheck disable=SC1090
		. "${ssm_module_file}"
	done
	unset ssm_module_file

	# ${STEAMSHIP_MODULES_SOURCED} contains the modules in the order they
	# were sourced.
}

steamship_modules_reset() {
	# Invoke every module "init" function to reset the configuration
	# variables to their defaults.
	for ssmr_module in ${STEAMSHIP_MODULES_SOURCED}; do
		ssmr_module_init_fn="steamship_${ssmr_module}_init"
		eval "${ssmr_module_init_fn}"
	done
	unset ssmr_module ssmr_module_init_fn
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} modules"
