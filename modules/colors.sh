# steamship/modules/colors.sh
# shellcheck shell=sh disable=SC2034

case " ${STEAMSHIP_MODULES_SOURCED} " in *" colors "*) return ;; esac

# Dependencies
steamship_load_module nonprintable

# Global color variables to be used by other modules.
STEAMSHIP_BLUE=
STEAMSHIP_CYAN=
STEAMSHIP_GRAY=
STEAMSHIP_GREEN=
STEAMSHIP_MAGENTA=
STEAMSHIP_RED=
STEAMSHIP_WHITE=
STEAMSHIP_YELLOW=
STEAMSHIP_NORMAL=
STEAMSHIP_BASE_COLOR=

steamship_colors_base_color_init() {
	# Set the value of STEAMSHIP_BASE_COLOR from ${STEAMSHIP_PROMPT_COLOR}.
	[ -n "${STEAMSHIP_PROMPT_COLOR}" ] || return
	sscbci_colorvar="STEAMSHIP_${STEAMSHIP_PROMPT_COLOR}"
	eval 'STEAMSHIP_BASE_COLOR=${'"${sscbci_colorvar}"'}'
	unset sscbci_colorvar
}

steamship_colors_init() {
	STEAMSHIP_PROMPT_COLOR='WHITE'

	ssci_start=${STEAMSHIP_ESC_START}
	ssci_end=${STEAMSHIP_ESC_END}

	ssci_bold=$(tput bold)
	if [ -n "${ssci_bold}" ]; then
		ssci_ncolors=$(tput colors)
		if [ -n "${ssci_ncolors}" ] && [ "${ssci_ncolors}" -ge 8 ]; then
			STEAMSHIP_BLUE=${ssci_start}${ssci_bold}$(tput setaf 4)${ssci_end}
			STEAMSHIP_CYAN=${ssci_start}${ssci_bold}$(tput setaf 6)${ssci_end}
			STEAMSHIP_GRAY=${ssci_start}${ssci_bold}$(tput setaf 0)${ssci_end}
			STEAMSHIP_GREEN=${ssci_start}${ssci_bold}$(tput setaf 2)${ssci_end}
			STEAMSHIP_MAGENTA=${ssci_start}${ssci_bold}$(tput setaf 5)${ssci_end}
			STEAMSHIP_RED=${ssci_start}${ssci_bold}$(tput setaf 1)${ssci_end}
			STEAMSHIP_WHITE=${ssci_start}${ssci_bold}$(tput setaf 7)${ssci_end}
			STEAMSHIP_YELLOW=${ssci_start}${ssci_bold}$(tput setaf 3)${ssci_end}
			STEAMSHIP_NORMAL=${ssci_start}$(tput sgr0)${ssci_end}
		else
			STEAMSHIP_BLUE=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_CYAN=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_GRAY=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_GREEN=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_MAGENTA=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_RED=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_WHITE=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_YELLOW=${ssci_start}${ssci_bold}${ssci_end}
			STEAMSHIP_NORMAL=${ssci_start}$(tput sgr0)${ssci_end}
		fi
		unset ssci_ncolors
	fi
	unset ssci_start ssci_end ssci_bold

	steamship_colors_base_color_init
}

steamship_colors_prompt() {
	# "prompt" function solely to reset the value of STEAMSHIP_BASE_COLOR
	# based on ${STEAMSHIP_PROMPT_COLOR}, which may be set by a theme or
	# by the user.
	#
	# It's very important that this function does not touch
	# ${STEAMSHIP_PROMPT_PS1} or else prefix decisions will be wrong for
	# the first visible section.
	#
	steamship_colors_base_color_init
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} colors"
