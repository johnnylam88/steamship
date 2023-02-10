# steamship/lib/themes.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" themes "*) return ;; esac

# Track which themes are available.
# shellcheck disable=SC2034
STEAMSHIP_THEMES=

STEAMSHIP_LIBS_INIT="${STEAMSHIP_LIBS_INIT} steamship_themes_init"

steamship_themes_init()
{
	[ -n "${STEAMSHIP_ROOT}" ] || return

	# Load all available themes in the `themes` directory.
	STEAMSHIP_THEMES=
	for sst_theme_file in "${STEAMSHIP_ROOT}"/themes/*.sh; do
		# shellcheck disable=SC1090
		. "${sst_theme_file}"
	done
	unset sst_theme_file

	# ${STEAMSHIP_THEMES} contains the list of available themes.
}

steamship_load_theme()
{
	[ ${#} -gt 0 ] || return

	case " ${STEAMSHIP_THEMES} " in
	*" ${1} "*)
		eval "steamship_theme_${1}"
		;;
	*)
		echo 1>&2 "steamship: \`${1}' theme not found."
		return 1
		;;
	esac
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} themes"
