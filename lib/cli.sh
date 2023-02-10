# steamship/lib/cli.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" cli "*) return ;; esac

# Dependencies
steamship_load_library config
steamship_load_library prompt
steamship_load_library themes

steamship_cli_usage() {
	# Print usage description to standard output.
	echo "Usage: steamship command [command_opts ...]"
	echo
	echo "COMMANDS:"
	echo "    edit"
	echo "    help"
	echo "    refresh"
	echo "    reset"
	echo "    theme"
}

steamship_cli_edit() {
	# Edit the user configuration file using ${EDITOR}.
	if [ -z "${STEAMSHIP_CONFIG}" ]; then
		# shellcheck disable=SC2016
		echo 1>&2 'steamship: ${STEAMSHIP_CONFIG} is unset or empty'
		return 1
	fi
	if [ ! -f "${STEAMSHIP_CONFIG}" ]; then
		echo 1>&2 'steamship: '"${STEAMSHIP_CONFIG}"' is missing'
		return 2
	fi
	if [ -z "${EDITOR}" ]; then
		# shellcheck disable=SC2016
		echo 1>&2 'steamship: ${EDITOR} is unset or empty'
		return 3
	fi
	${EDITOR} "${STEAMSHIP_CONFIG}"
	steamship_cli_reset
}

steamship_cli_help() {
	steamship_cli_usage
}

steamship_cli_refresh() {
	# Rebuild prompt strings, but only if not called from within the
	# configuration file.
	[ -n "${steamship_config_sourcing}" ] || steamship_prompt_refresh
}

steamship_cli_reset() {
	# Reset to default settings.
	steamship_modules_reset
	# Load the default theme settings first.
	steamship_load_theme starship
	# Load the user configuration file to modify the starship theme.
	# The user configuration file may possibly invoke "steamship theme"
	# to load another theme altogether.
	steamship_config
	steamship_cli_refresh
}

steamship_cli_theme() {
	if [ "${#}" = 0 ]; then
		echo 1>&2 "steamship: \`theme' missing required name"
		steamship_cli_usage 1>&2
		return 1
	fi

	# Load the named theme.
	steamship_load_theme "${@}"
	steamship_cli_refresh
}

steamship() {
	if [ "${#}" = 0 ]; then
		echo 1>&2 "steamship: missing required command"
		steamship_cli_usage 1>&2
		return 1
	fi

	sscli_command=${1}; shift

	# The commands allowed to be used in the user configuration file.
	sscli_config_allowed_commands="reset theme"
	if [ -n "${steamship_config_sourcing}" ]; then
		case " ${sscli_config_allowed_commands} " in
		*" ${sscli_command} "*)
			: "command allowed in confguration file"
			;;
		*)
			echo 1>&2 "steamship: \`${1}' not allowed in configuration file"
			steamship_cli_usage 1>&2
			return 2
			;;
		esac
	fi

	case ${sscli_command} in
	edit|help|refresh|reset|theme)
		: "valid command"
		;;
	*)
		echo 1>&2 "steamship: \`${sscli_command}' is not a valid command"
		steamship_cli_usage 1>&2
		return 3
		;;
	esac

	sscli_command_fn=
	eval 'sscli_command_fn=steamship_cli_'"${sscli_command}"
	"${sscli_command_fn}" "${@}"
	unset sscli_command sscli_command_fn sscli_config_allowed_commands
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} cli"
