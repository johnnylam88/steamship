# steamship/steamship.sh
# shellcheck shell=sh

steamship_init() {
	# ${STEAMSHIP_ROOT} is the path to the steamship main directory.
	if [ -z "${STEAMSHIP_ROOT}" ]; then
		if [ -n "${BASH_VERSION}" ]; then
			# Bash has ${BASH_SOURCE[0]} as the path to the sourced file.
			eval 'STEAMSHIP_ROOT=${BASH_SOURCE[0]%/*}'
		elif [ -n "${ZSH_VERSION}" ]; then
			# ZSH has ${0} as the path to the sourced file, but only if
			# the shell option FUNCTION_ARGZERO is toggled on.
			ssi_zsh_argzero=
			# shellcheck disable=SC2034
			eval '[[ -o FUNCTION_ARGZERO ]]' 2>/dev/null && ssh_zsh_argzero='true'
			[ -z "${ssi_zsh_argzero}" ] || setopt FUNCTION_ARGZERO
			STEAMSHIP_ROOT=${0%/*}
			[ -n "${ssi_zsh_argzero}" ] || unsetopt FUNCTION_ARGZERO
			unset ssi_zsh_argzero
		else
			# Modern KSH has ${.sh.file} as the path to the sourced file.
			if eval '[[ -n "${.sh.file}" ]]' 2>/dev/null; then
				eval 'STEAMSHIP_ROOT=${.sh.file%/*}'
			fi
		fi
		# Default path.
		: "${STEAMSHIP_ROOT="${HOME}/.local/share/steamship"}"
	fi
}

steamship_load_library() {
	if [ -f "${STEAMSHIP_ROOT}/lib/${1}.sh" ]; then
		# shellcheck disable=SC1090
		. "${STEAMSHIP_ROOT}/lib/${1}.sh"
	else
		echo 1>&2 "steamship: \`${1}' library not found."
		return 1
	fi
}

steamship_load() {
	# Load all libraries in the `lib` directory.
	# shellcheck disable=SC2034
	STEAMSHIP_LIBS_SOURCED=
	STEAMSHIP_LIBS_INIT=
	for ssl_lib_file in "${STEAMSHIP_ROOT}"/lib/*.sh; do
		# shellcheck disable=SC1090
		. "${ssl_lib_file}"
	done
	# Run "init" function for each library.
	for ssl_lib_init_fn in ${STEAMSHIP_LIBS_INIT}; do
		eval "${ssl_lib_init_fn}"
	done
	unset ssl_lib_file ssl_lib_init_fn
}

steamship() {
	case ${1} in
	refresh)
		# Rebuild prompt strings after configuration changes.
		steamship_prompt_refresh
		;;
	reset)
		# Reset to default settings.
		steamship_modules_reset
		steamship_config
		steamship_load_theme "${STEAMSHIP_THEME:-"starship"}"
		steamship_prompt_refresh
		;;
	theme)
		shift
		steamship_load_theme "${@}"
		steamship_prompt_refresh
		;;
	esac
}

steamship_init
steamship_load
steamship reset
