# steamship/lib/cli.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" cli "*) return ;; esac

# Dependencies
steamship_load_library prompt
steamship_load_library themes

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

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} cli"
