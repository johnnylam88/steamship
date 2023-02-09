# steamship/lib/cli.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" cli "*) return ;; esac

# Dependencies
steamship_load_library prompt
steamship_load_library themes

steamship() {
	sscli_do_refresh=
	case ${1} in
	refresh)
		# Rebuild prompt strings after configuration changes.
		sscli_do_refresh='yes'
		;;
	reset)
		# Reset to default settings.
		steamship_modules_reset
		# Load the default theme settings first.
		steamship_load_theme starship
		# Load the user configuration file to modify the starship theme.
		# The user configuration file may possibly invoke "steamship theme"
		# to load another theme altogether.
		steamship_config
		sscli_do_refresh='yes'
		;;
	theme)
		shift
		steamship_load_theme "${@}"
		sscli_do_refresh='yes'
		;;
	esac
	# Refresh as final command if requested, but only if not called from
	# within the configuration file.
	if	[ -n "${sscli_do_refresh}" ] &&
		[ -z "${steamship_config_sourcing}" ]
	then
		steamship_prompt_refresh
	fi
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} cli"
